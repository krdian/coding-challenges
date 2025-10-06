variable "aws_account_id" {
  description = "The AWS account ID where the EKS cluster will be created"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key used for encrypting EKS secrets"
  type        = string
}
