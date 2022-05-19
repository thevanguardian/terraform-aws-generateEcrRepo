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
  count      = var.lifecyclePolicies != "" ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = var.lifecyclePolicies
}

resource "aws_ecr_replication_configuration" "this" {
  count = var.replicationDestinations != [] || var.replicationFilter != {} ? 1 : 0
  replication_configuration {
    rule {
      dynamic "destination" {
        for_each = var.replicationDestinations
        content {
          region      = destination.value["region"]
          registry_id = destination.value["registry_id"]
        }
      }
      repository_filter {
        filter      = var.replicationFilter["filter"]
        filter_type = var.replicationFilter["filter_type"]
      }
    }
  }
}

resource "aws_ecr_repository_policy" "this" {
  count      = var.repositoryPolicy != "{}" ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = var.repositoryPolicy
}
