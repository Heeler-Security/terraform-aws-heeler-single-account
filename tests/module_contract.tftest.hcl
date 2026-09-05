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

override_resource {
  target = aws_iam_policy.heeler_read_only_policy
  values = {
    arn = "arn:aws:iam::123456789012:policy/Heeler"
  }
}

override_resource {
  target = aws_iam_policy.heeler_eks_policy
  values = {
    arn = "arn:aws:iam::123456789012:policy/HeelerEKS"
  }
}

variables {
  external_id = "heeler-test-external-id"
}

run "apply_single_attachment_contract" {
  command = apply

  assert {
    condition     = output.heeler_role_arn == "arn:aws:iam::123456789012:role/heeler-terraform"
    error_message = "heeler_role_arn must expose the IAM role ARN required by the Heeler form."
  }

  assert {
    condition     = jsondecode(aws_iam_role.heeler.assume_role_policy).Statement[0].Principal.AWS == "arn:aws:iam::168777450829:role/prod-1-role"
    error_message = "The module must default to Heeler's production role ARN."
  }

  assert {
    condition = toset([
      aws_iam_role_policy_attachment.read_only.policy_arn,
      aws_iam_role_policy_attachment.heeler_read_only.policy_arn,
      aws_iam_role_policy_attachment.heeler_eks.policy_arn,
      ]) == toset([
      "arn:aws:iam::aws:policy/ReadOnlyAccess",
      aws_iam_policy.heeler_read_only_policy.arn,
      aws_iam_policy.heeler_eks_policy.arn,
    ])
    error_message = "All three policies must use dedicated role policy attachments."
  }
}

run "second_plan_is_clean" {
  command = plan
}
