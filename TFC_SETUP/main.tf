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
  auto_apply         = true
  execution_mode     = "remote"
  terraform_version  = var.tfe_version
}

resource "tfe_sentinel_policy" "demo" {
  name         = "restrict-ec2-instance-type"
  description  = "sentinel policy that only allows t2.micro instance types"
  organization = var.tfe_org
  enforce_mode = "soft-mandatory"
  policy       = <<EOT
    # This policy uses the Sentinel tfplan/v2 import to require that
    # all EC2 instances have instance types from an allowed list

    # Import common-functions/tfplan-functions/tfplan-functions.sentinel
    # with alias "plan"
    import "tfplan-functions" as plan

    # Allowed EC2 Instance Types
    # Include "null" to allow missing or computed values
    allowed_types = ["t2.micro"]

    # Get all EC2 instances
    allEC2Instances = plan.find_resources("aws_instance")

    # Filter to EC2 instances with violations
    # Warnings will be printed for all violations since the last parameter is true
    violatingEC2Instances = plan.filter_attribute_not_in_list(allEC2Instances,
                            "instance_type", allowed_types, true)

    # Count violations
    violations = length(violatingEC2Instances["messages"])

    # Main rule
    main = rule {
      violations is 0
    }
  EOT
}

resource "tfe_policy_set" "demo" {
  name          = "aws-demo-policy-set"
  description   = "policy set for the aws demo"
  organization  = var.tfe_org
  policy_ids    = [tfe_sentinel_policy.demo.id]
  workspace_ids = [tfe_workspace.demo.id]
}