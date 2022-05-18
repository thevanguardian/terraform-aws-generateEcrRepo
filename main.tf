resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = upper(var.tagMutability)

  encryption_configuration {
    encryption_type = var.encryptionConfiguration["encryption_type"]
    kms_key         = var.encryptionConfiguration["kms_key"]
  }
  image_scanning_configuration {
    scan_on_push = var.imageScanningConfig
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  count = var.lifecyclePolicies != "" ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = var.lifecyclePolicies
}

resource "aws_ecr_replication_configuration" "this" {
  for_each = var.replicationConfiguration
  replication_configuration {
    dynamic "rule" {
      for_each = var.replicationConfiguration
      content {
        destination {
          region      = rule.value["region"]
          registry_id = rule.value["registry_id"]
        }
        repository_filter {
          filter      = rule.value["filter"]
          filter_type = rule.value["filter_type"]
        }
      }
    }
  }
}

resource "aws_ecr_repository_policy" "this" {
  count = var.repositoryPolicy != "{}" ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = var.repositoryPolicy
}