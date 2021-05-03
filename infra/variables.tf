variable "project_id" {
  description = "project id"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
}

variable "tag" {
  description = "current application tag"
  type = string
  default = "v1"
}
