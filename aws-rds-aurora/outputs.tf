output "cf_id" {
  value = aws_cloudformation_stack.cluster.id
}

output "cf_outputs" {
  value = aws_cloudformation_stack.cluster.outputs
}