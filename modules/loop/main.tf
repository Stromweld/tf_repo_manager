module "repository" {
  source = "../GitHub/repository"

  name                            = var.name
  description                     = try(var.repo_config.description, null)
  visibility                      = try(var.repo_config.visibility, "public")
  is_template                     = try(var.repo_config.is_template, false)
  gitignore_template              = try(var.repo_config.gitignore_template, null)
  archived                        = try(var.repo_config.archived, null)
  pages                           = try(var.repo_config.pages, {})
  topics                          = try(var.repo_config.topics, [])
  template                        = try(var.repo_config.template, {})
  github_repository_collaborators = try(var.repo_config.github_repository_collaborators, [])
  github_branch = try(var.repo_config.github_branch, {})
  github_branch_protection = try(var.repo_config.github_branch_protection, { main = {} })
  cookbook                        = var.cookbook
  terraform                       = var.terraform
  tf_module                       = var.tf_module
}

module "tf_workspace" {
  source   = "../TerraformCloud/workspaces"
  for_each = var.tf_workspaces

  name                = each.key == "default" ? var.name : "${var.name}:${each.key}"
  vcs_repo            = try(each.value.vcs_repo, { enabled = false })
  repo_identifier     = module.repository.node_id
  oauth_token_id      = var.oauth_token_id
  description         = try(each.value.description, var.repo_config.description, null)
  organization        = try(each.value.organization, "Stromweld")
  speculative_enabled = try(each.value.speculative_enabled, true)
}

module "tf_module" {
  source = "../TerraformCloud/registry_module"
  count  = var.tf_module ? 1 : 0

  vcs_display_identifier = module.repository.node_id
  vcs_identifier         = module.repository.full_name
  oauth_token_id         = var.oauth_token_id
}
