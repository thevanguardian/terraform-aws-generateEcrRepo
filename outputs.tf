output "repositoryArn" {
  value = aws_ecr_repository.this.arn
}
output "registryId" {
  value = aws_ecr_repository.this.registry_id
}
output "repositoryUrl" {
  value = aws_ecr_repository.this.repository_url
}
output "repositoryPolicy" {
  value = jsondecode(var.repositoryPolicy)
}
output "lifecyclePolicies" {
  value = jsondecode(var.lifecyclePolicies)
}