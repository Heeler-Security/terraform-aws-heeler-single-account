#!/usr/bin/env sh
set -eu

test_log="$(mktemp)"
trap 'rm -f "$test_log"' EXIT

if ! terraform test -no-color -verbose -test-directory=upgrade-tests >"$test_log" 2>&1; then
  cat "$test_log"
  exit 1
fi

cat "$test_log"

if ! grep -F "aws_iam_policy_attachment.heeler_eks_policy_attachment will no longer be managed by Terraform, but will not be destroyed" "$test_log" >/dev/null; then
  echo "The legacy EKS attachment was not removed from state without destroy." >&2
  exit 1
fi

if ! awk '
  /run "preview_legacy_attachment_upgrade"/ { in_upgrade = 1 }
  /run "apply_legacy_attachment_upgrade"/ { in_upgrade = 0 }
  in_upgrade && /0 to destroy/ { zero_destroy = 1 }
  END { exit zero_destroy ? 0 : 1 }
' "$test_log"; then
  echo "The legacy attachment upgrade preview did not prove a zero-destroy plan." >&2
  exit 1
fi

if ! awk '
  /run "second_legacy_upgrade_plan_is_clean"/ { in_second_plan = 1 }
  in_second_plan && /No changes\./ { clean_plan = 1 }
  END { exit clean_plan ? 0 : 1 }
' "$test_log"; then
  echo "The second legacy attachment upgrade plan was not clean." >&2
  exit 1
fi
