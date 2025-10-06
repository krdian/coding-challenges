variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = ""
}

variable "subnets" {
  description = "A map of subnet names to CIDR blocks"
  type        = map(string)
  default     = {}
}