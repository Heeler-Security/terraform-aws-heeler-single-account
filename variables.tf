variable "role_name" {
  description = "The name of the role that Heeler will assume in each account."
  type        = string
  default     = "heeler-terraform"
}

variable "heeler_policy_name" {
  description = "The name of the IAM Policy that will be assigned to Heeler roles"
  type        = string
  default     = "Heeler"
}

variable "heeler_eks_policy" {
  description = "The name of the IAM Policy that is used for communication with EKS clusters"
  type        = string
  default     = "HeelerEKS"
}

variable "heeler_security_role_arn" {
  description = "The production role used by Heeler to assume roles within customer accounts. Override only when instructed by Heeler support."
  type        = string
  default     = "arn:aws:iam::168777450829:role/prod-1-role"
}

variable "external_id" {
  description = "External Id to use when Heeler assumes the role in the account."
  type        = string
}
