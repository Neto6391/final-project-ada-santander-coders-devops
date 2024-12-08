output "lambda_function_arns" {
  description = "ARNs das funções Lambda criadas."
  value       = { for k, v in aws_lambda_function.ada_lambda : k => v.arn }
}

output "process_file_lambda_arn" {
  description = "ARN da função Lambda process_file."
  value       = local.process_file_lambda.arn
}

output "notify_user_lambda_arn" {
  description = "ARN da função Lambda notify_user."
  value       = local.notify_user_lambda.arn
}

output "lambda_execution_role" {
  description = "IAM Role associado às funções Lambda."
  value       = aws_iam_role.lambda_execution_role.arn
}

output "lambda_policy" {
  description = "IAM Policy aplicada às funções Lambda."
  value       = aws_iam_policy.lambda_policy.arn
}