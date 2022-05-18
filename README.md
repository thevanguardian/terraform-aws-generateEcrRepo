# Overview
Standardizes creation of ECR Repositories and their respective replication configurations and/or policies.
# Details
Dynamically creates an ECR repository based on the attributes assigned during module call. It supports encryption, tag mutability, image scanning, replication configuration, lifecycle and repository policies.

## Available Inputs
- name (required, string): Name of the ECR repository.
- tagMutability (optional, string): Defaults to MUTABLE, strings are uppercased at runtime.
- encryptionConfiguration (optional, map): Expects the following attributes
  - encryption_type = AES256 / KMS 
  - kms_key = <KMS ARN> or null
- imageScanningConfig (optional, bool): Setting for image scanning after push. Default: true
- lifecyclePolicies (optional, string): JSON formatted lifecycle policies for ECR.
- replicationConfiguration (optional, set): Set of maps expecting the following attributes
  - region
  - registry_id
  - filter
  - filter_type
- repositoryPolicy (optional, string): IAM formatted policy to assign to the repository. Can be generated with EOF, jsonencode, or aws_iam_policy_document.

# Example Usage
```hcl
module "this" {
  source = "thevanguardian/generateEcrRepo/aws"
  version = "1.0.0"
  name          = "test-for-ecr"
  tagMutability = "immutable"
  encryptionConfiguration = {
    encryption_type = null
    kms_key         = null
  }
  imageScanningConfig = false
  repositoryPolicy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "repositorypolicy",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::123456789101:user/thisuser",
          "arn:aws:iam::123456789101:role/thatrole"
        ]
      },
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchDeleteImage",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:DeleteRepository",
        "ecr:DeleteRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:GetAuthorizationToken",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:InitiateLayerUpload",
        "ecr:ListImages",
        "ecr:PutImage",
        "ecr:SetRepositoryPolicy",
        "ecr:UploadLayerPart"
      ]
    }
  ]
})

  lifecyclePolicies = jsonencode({
    "rules" : [
      {
        "rulePriority" : 1,
        "description" : "Expire images older than 14 days",
        "selection" : {
          "tagStatus" : "untagged",
          "countType" : "sinceImagePushed",
          "countUnit" : "days",
          "countNumber" : 14
        },
        "action" : {
          "type" : "expire"
        }
      },
      {
        "rulePriority" : 2,
        "description" : "test",
        "selection" : {
          "tagStatus" : "any",
          "countType" : "sinceImagePushed",
          "countUnit" : "days",
          "countNumber" : 1
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  })
}
```