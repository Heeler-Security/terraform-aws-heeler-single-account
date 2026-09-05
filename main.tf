resource "aws_iam_policy" "heeler_read_only_policy" {
  description = "Heeler policy that denies access to certain actions and allows Lambda GetFunction and SSM SendCommand"
  name        = var.heeler_policy_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Deny"
        Resource = "*"
        Action = [
          "cloudformation:GetTemplate",
          "dynamodb:GetItem",
          "dynamodb:BatchGetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "ec2:GetConsoleOutput",
          "ec2:GetConsoleScreenshot",
          "kinesis:Get*",
          "logs:GetLogEvents",
          "s3:GetObject",
          "sdb:Select*",
          "sqs:ReceiveMessage"
        ]
      },
      {
        Effect   = "Allow"
        Resource = "*"
        Action = [
          "lambda:GetFunction",
          "ssm:SendCommand"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "heeler_eks_policy" {
  name        = var.heeler_eks_policy
  description = "Heeler policy that allows configuring API access to EKS clusters"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Resource = "*"
        Action = [
          "eks:TagResource"
        ]
      },
      {
        Effect   = "Allow"
        Resource = "*"
        Action = [
          "eks:CreateAccessEntry"
        ]
        Condition = {
          ArnEquals = {
            "eks:principalArn" = aws_iam_role.heeler.arn
          }
        }
      },
      {
        Effect   = "Allow"
        Resource = "*"
        Action = [
          "eks:AssociateAccessPolicy"
        ]
        Condition = {
          ArnEquals = {
            "eks:policyArn" = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminViewPolicy"
          }
        }
      }
    ]
  })
}


resource "aws_iam_role" "heeler" {
  name                 = var.role_name
  description          = "Access for Heeler to fetch resources from account and allow API access to EKS clusters"
  max_session_duration = 28800
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.heeler_security_role_arn
        }
        Action = [
          "sts:AssumeRole",
        ]
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.external_id
          }
        }
      },
      {
        Effect = "Allow"
        Principal = {
          AWS = var.heeler_security_role_arn
        }
        Action = "sts:TagSession"
      }
    ]
  })

  # Older module versions managed two attachments through the deprecated
  # managed_policy_arns argument. Ignore that legacy state while the dedicated
  # attachment resources below take ownership, avoiding a detach/reattach
  # window during upgrade.
  lifecycle {
    ignore_changes = [managed_policy_arns]
  }
}

removed {
  from = aws_iam_policy_attachment.heeler_eks_policy_attachment

  lifecycle {
    destroy = false
  }
}

resource "aws_iam_role_policy_attachment" "read_only" {
  role       = aws_iam_role.heeler.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "heeler_read_only" {
  role       = aws_iam_role.heeler.name
  policy_arn = aws_iam_policy.heeler_read_only_policy.arn
}

resource "aws_iam_role_policy_attachment" "heeler_eks" {
  role       = aws_iam_role.heeler.name
  policy_arn = aws_iam_policy.heeler_eks_policy.arn
}
