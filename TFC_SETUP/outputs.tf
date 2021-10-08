output "doormat_command" {
  value = "doormat aws --account se_demos_dev --tf-push --tf-workspace ${tfe_workspace.demo1.name},${tfe_workspace.demo2.name} --tf-organization ${var.tfe_org}"
}