variable "name" {
  type        = string
  description = "name (str): Repository name to be created."
}
variable "tagMutability" {
  type        = string
  description = "tagMutability (str): Mutable or Immutable."
  default     = "MUTABLE"
}
variable "encryptionConfiguration" {
  type        = map(any)
  description = "encryptionConfiguration (map): Supports two attributes, encryption_type = <AES256 / KMS>, and kms_key = <KMS ARN or null>"
  default = {
    encryption_type = "KMS"
    kms_key         = null
  }
}
variable "imageScanningConfig" {
  type        = bool
  description = "imageScanningConfig (bool): Whether images are scanned after being pushed to the repository. Overridden by account registry configurations."
  default     = true
}
variable "lifecyclePolicies" {
  type        = string
  description = "lifecyclePolicies (str): String of JSON formatted lifecycle policies."
  default     = ""
}
variable "replicationDestinations" {
  type        = set(any)
  description = "replicationDestinations (set): Set of Maps using the following attributes. region, registry_id"
  default     = []
}
variable "replicationFilter" {
  type        = map(any)
  description = "replicationFilter (map): Map identifying the repository filter to put in place for replication. Supports the attributes of filter, and filter_type."
  default     = {}
}
variable "repositoryPolicy" {
  type        = string
  description = "repositoryPolicy (str): IAM formatted policy using EOF, jsonencode, or aws_iam_policy_document."
  default     = "{}"
}
