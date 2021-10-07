terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.26.1"
    }
  }
}

provider "tfe" {
  hostname = var.tfe_host
  token    = var.tfe_token
}

resource "tfe_workspace" "demo" {
  name               = var.workspace_name
  organization       = var.tfe_org
  description        = "This is a demo workspace to showcase building AWS infrastructure"
  allow_destroy_plan = true
  auto_apply         = false
  execution_mode     = "remote"
  terraform_version  = var.tfe_version
}

resource "tfe_sentinel_policy" "demo" {
  name         = "restrict-ec2-instance-types"
  description  = "policy for restricting to smaller instance types only"
  organization = var.tfe_org
  policy       = file("./sentinel_policies/restrict-instance-type.sentinel")
  enforce_mode = "soft-mandatory"
}

resource "tfe_policy_set" "demo" {
  name          = "aws-demo-policy-set"
  description   = "policy set for the aws demo"
  organization  = var.tfe_org
  workspace_ids = [tfe_workspace.demo.id]
  policy_ids    = [tfe_sentinel_policy.demo.id]
}