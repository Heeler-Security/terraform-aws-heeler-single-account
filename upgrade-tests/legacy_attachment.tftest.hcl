mock_provider "aws" {
  mock_resource "aws_iam_role" {
    defaults = {
      arn  = "arn:aws:iam::123456789012:role/heeler-terraform"
      name = "heeler-terraform"
    }
  }

  mock_resource "aws_iam_policy" {
    defaults = {
      arn = "arn:aws:iam::123456789012:policy/heeler-test"
    }
  }
}

variables {
  external_id              = "heeler-test-external-id"
  heeler_security_role_arn = "arn:aws:iam::168777450829:role/heeler-security"
}

run "seed_legacy_attachment_state" {
  command   = apply
  state_key = "legacy-upgrade"

  module {
    source = "./upgrade-tests/fixtures/v1"
  }
}

run "preview_legacy_attachment_upgrade" {
  command   = plan
  state_key = "legacy-upgrade"
}

run "apply_legacy_attachment_upgrade" {
  command   = apply
  state_key = "legacy-upgrade"
}

run "second_legacy_upgrade_plan_is_clean" {
  command   = plan
  state_key = "legacy-upgrade"
}
