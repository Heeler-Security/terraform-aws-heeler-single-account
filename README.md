## Requirements

- Terraform `>= 1.11.0, < 2.0.0`
- HashiCorp AWS provider `>= 5.0.0, < 7.0.0`

The tested compatibility matrix is:

| Terraform | AWS provider |
|---|---|
| 1.11.0 | 5.0.0 |
| 1.16.1 | 6.63.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0, < 7.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.heeler_eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.heeler_read_only_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.heeler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.heeler_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.heeler_read_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.read_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | External Id to use when Heeler assumes the role in the account. | `string` | n/a | yes |
| <a name="input_heeler_eks_policy"></a> [heeler\_eks\_policy](#input\_heeler\_eks\_policy) | The name of the IAM Policy that is used for communication with EKS clusters | `string` | `"HeelerEKS"` | no |
| <a name="input_heeler_policy_name"></a> [heeler\_policy\_name](#input\_heeler\_policy\_name) | The name of the IAM Policy that will be assigned to Heeler roles | `string` | `"Heeler"` | no |
| <a name="input_heeler_security_role_arn"></a> [heeler\_security\_role\_arn](#input\_heeler\_security\_role\_arn) | The production role used by Heeler to assume roles within customer accounts. Override only when instructed by Heeler support. | `string` | `"arn:aws:iam::168777450829:role/prod-1-role"` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | The name of the role that Heeler will assume in each account. | `string` | `"heeler-terraform"` | no |

## Outputs

| Name | Description |
|---|---|
| `heeler_role_arn` | IAM role ARN to enter in the Heeler Role ARN field. |

Retrieve it after apply:

```bash
terraform output -raw heeler_role_arn
```

## Upgrade from 1.0.0 to 2.0.0

This attachment-ownership migration and its higher Terraform/provider minimums require the `2.0.0` major release. Keep Terraform and the AWS provider within the supported ranges above. Run `terraform init -upgrade`, review `terraform plan`, apply, and require a clean second plan. The module now manages all three policies with dedicated role-policy attachment resources. Its state transition preserves the legacy EKS attachment instead of detaching it during upgrade.

The `external_id` input must exactly match the value generated in the Heeler setup wizard. It is a confused-deputy binding used in the role trust policy, not a conventional authentication secret.

The module defaults `heeler_security_role_arn` to Heeler's production role. Override it only when Heeler support provides a different role ARN.

## Validate the module

```bash
terraform fmt -check -recursive
terraform init
./tests/assert-clean-second-plan.sh
```
