
output "ohio_id" {
  description = "The ID of the us-west-2 instance"
  value       = aws_instance.app_server.id
}

output "ohio_arn" {
  description = "The ARN of the us-west-2 instance"
  value       = aws_instance.app_server.arn
}

output "london_id" {
  description = "The ID of the eu-west-2 instance"
  value       = aws_instance.second_app_server.id
}

output "london_arn" {
  description = "The ARN of the eu-west-2 instance"
  value       = aws_instance.second_app_server.arn
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table"
}