output "doormat_command" {
  value = "doormat aws --account se_demos_dev --tf-push --tf-workspace ${tfe_workspace.demo.name} --tf-organization ${var.tfe_org}"
}