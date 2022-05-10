module "looper" {
  source   = "./loop"
  for_each = var.github_repos

  name           = each.key
  repo_config    = each.value
  tf_workspaces  = try(each.value.tf_workspaces, {})
  oauth_token_id = var.oauth_token_id
  cookbook       = var.cookbook
  terraform      = var.terraform
  tf_module      = var.tf_module
}
