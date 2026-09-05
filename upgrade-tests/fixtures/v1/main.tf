terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

variable "external_id" {
  type = string
}

variable "heeler_security_role_arn" {
  type = string
}

resource "aws_iam_policy" "heeler_read_only_policy" {
  name = "Heeler"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Deny"
      Resource = "*"
      Action   = ["s3:GetObject"]
    }]
  })
}

resource "aws_iam_policy" "heeler_eks_policy" {
  name = "HeelerEKS"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Resource = "*"
      Action   = ["eks:TagResource"]
    }]
  })
}

resource "aws_iam_role" "heeler" {
  name = "heeler-terraform"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    aws_iam_policy.heeler_read_only_policy.arn,
  ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = var.heeler_security_role_arn
      }
      Action = "sts:AssumeRole"
      Condition = {
        StringEquals = {
          "sts:ExternalId" = var.external_id
        }
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "heeler_eks_policy_attachment" {
  name       = "HeelerEKS-TF"
  policy_arn = aws_iam_policy.heeler_eks_policy.arn
  roles      = [aws_iam_role.heeler.name]
}
