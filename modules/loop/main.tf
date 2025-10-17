locals {
  cookbook_secrets  = try(var.repo_config.github_actions_secrets, { SUPERMARKET_KEY = { plaintext_value = var.supermarket_key } }, {})
  terraform_secrets = try(var.repo_config.github_actions_secrets, { TOKEN_TFC = { plaintext_value = var.tfc_token } }, {})
}

module "repository" {
  source  = "app.terraform.io/Stromweld/repositories/github"
  version = ">= 1.0.0"

  name                            = var.name
  description                     = try(var.repo_config.description, null)
  visibility                      = try(var.repo_config.visibility, "private")
  is_template                     = try(var.repo_config.is_template, false)
  gitignore_template              = try(var.repo_config.gitignore_template, null)
  archived                        = try(var.repo_config.archived, null)
  pages                           = try(var.repo_config.pages, {})
  topics                          = try(var.repo_config.topics, [])
  template                        = try(var.repo_config.template, {})
  github_repository_collaborators = try(var.repo_config.github_repository_collaborators, [])
  github_branch                   = try(var.repo_config.github_branch, {})
  github_branch_protection        = try(var.repo_config.visibility == "private", false) ? {} : try(var.repo_config.github_branch_protection, { main = {} })
  github_actions_secrets          = try(var.repo_config.github_actions_secrets, var.cookbook ? local.cookbook_secrets : var.terraform ? local.terraform_secrets : var.tf_module ? local.terraform_secrets : {})
  cookbook                        = var.cookbook
  terraform                       = var.terraform
  tf_module                       = var.tf_module
}

module "tf_workspace" {
  source   = "app.terraform.io/Stromweld/workspaces/tfe"
  version  = ">= 1.0.0"
  for_each = var.tf_workspaces

  name                = each.key == "default" ? var.name : "${var.name}:${each.key}"
  vcs_repo            = try(each.value.vcs_repo, { enabled = false })
  description         = try(each.value.description, var.repo_config.description, null)
  organization        = try(each.value.organization, "Stromweld")
  speculative_enabled = try(each.value.speculative_enabled, true)
  terraform_version   = try(each.value.terraform_vesion, "latest")
}

module "tf_module" {
  source  = "app.terraform.io/Stromweld/private-modules/tfe"
  version = ">= 1.0.0"
  count   = var.tf_module ? 1 : 0

  vcs_display_identifier = module.repository.full_name
  vcs_identifier         = module.repository.full_name
  oauth_token_id         = var.oauth_token_id
}
