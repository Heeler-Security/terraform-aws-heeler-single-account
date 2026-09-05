#!/usr/bin/env sh
set -eu

if grep -F 'managed_policy_arns =' main.tf >/dev/null; then
  echo "main.tf must not configure the deprecated managed_policy_arns argument." >&2
  exit 1
fi

if grep -F 'resource "aws_iam_policy_attachment"' main.tf >/dev/null; then
  echo "main.tf must not use the account-wide aws_iam_policy_attachment resource." >&2
  exit 1
fi

for attachment in read_only heeler_read_only heeler_eks; do
  if ! grep -F "resource \"aws_iam_role_policy_attachment\" \"$attachment\"" main.tf >/dev/null; then
    echo "Missing dedicated role policy attachment: $attachment." >&2
    exit 1
  fi
done

if ! grep -F 'ignore_changes = [managed_policy_arns]' main.tf >/dev/null; then
  echo "The legacy managed_policy_arns migration guard is missing." >&2
  exit 1
fi

test_log="$(mktemp)"
trap 'rm -f "$test_log"' EXIT

if ! terraform test -no-color -verbose -filter=tests/module_contract.tftest.hcl >"$test_log" 2>&1; then
  cat "$test_log"
  exit 1
fi

cat "$test_log"

if ! awk '
  /run "second_plan_is_clean"/ { in_second_plan = 1 }
  in_second_plan && /No changes\./ { clean_plan = 1 }
  END { exit clean_plan ? 0 : 1 }
' "$test_log"; then
  echo "The second Terraform plan was not clean." >&2
  exit 1
fi
