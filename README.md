## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.heeler_eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.heeler_read_only_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.heeler_eks_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.heeler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | External Id to use when Heeler assumes the role in the account. | `string` | n/a | yes |
| <a name="input_heeler_eks_policy"></a> [heeler\_eks\_policy](#input\_heeler\_eks\_policy) | The name of the IAM Policy that is used for communication with EKS clusters | `string` | `"HeelerEKS"` | no |
| <a name="input_heeler_policy_name"></a> [heeler\_policy\_name](#input\_heeler\_policy\_name) | The name of the IAM Policy that will be assigned to Heeler roles | `string` | `"Heeler"` | no |
| <a name="input_heeler_security_role_arn"></a> [heeler\_security\_role\_arn](#input\_heeler\_security\_role\_arn) | The role used by Heeler to assume roles within the customer accounts. This is available in the documentation or in the onboarding UI. | `string` | n/a | yes |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | The name of the role that Heeler will assume in each account. | `string` | `"heeler-terraform"` | no |

## Outputs

No outputs.
