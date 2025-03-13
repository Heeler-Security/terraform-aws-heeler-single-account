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
  description = "The role used by Heeler to assume roles within the customer accounts. This is available in the documentation or in the onboarding UI."
  type        = string
}

variable "external_id" {
  description = "External Id to use when Heeler assumes the role in the account."
  type        = string
}

