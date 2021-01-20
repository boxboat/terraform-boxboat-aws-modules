variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket"
}

variable "tags" {
  type        = map(string)
  description = "The list of AWS Tags to use when creating the AWS Code Build resources"
}