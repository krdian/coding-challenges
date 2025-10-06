output "subnet_ids" {
  description = "The IDs of the subnets"
  value       = [for subnet in aws_subnet.this : subnet.id]
}
