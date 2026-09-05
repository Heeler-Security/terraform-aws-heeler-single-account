output "heeler_role_arn" {
  description = "ARN of the IAM role to enter in the Heeler Role ARN field."
  value       = aws_iam_role.heeler.arn
}
