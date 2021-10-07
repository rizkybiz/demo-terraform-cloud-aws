variable "workspace_name" {
  description = "the name of the TFE/C workspace to create"
  default     = "terraform-cloud-demo-aws"
}

variable "tfe_org" {
  description = "the name of the organization to create the workspace under"
}

variable "tfe_token" {
  description = "the TFE/C token for authentication"
}

variable "tfe_host" {
  description = "the hostname for the TFE installation"
  default     = "app.terraform.io"
}

variable "tfe_version" {
  description = "the version of the TFC/E workspace"
}