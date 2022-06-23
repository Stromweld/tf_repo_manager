provider "github" {
  owner = "Stromweld"
  token = var.github_token
}

provider "tfe" {
  token = var.tfc_token
}

resource "tfe_oauth_client" "github" {
  organization     = "Stromweld"
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_token
  service_provider = "github"
}

module "chef_cb_repos" {
  source = "./modules"

  github_repos    = var.vars_chef_cb_repos
  cookbook        = true
  supermarket_key = var.supermarket_key
}

module "other_repos" {
  source = "./modules"

  github_repos = var.vars_other_repos
}

module "tf_modules_repos" {
  source = "./modules"

  github_repos   = var.vars_tf_module_repos
  github_token   = var.github_token
  tf_module      = true
  oauth_token_id = tfe_oauth_client.github.oauth_token_id
}

module "tf_repos" {
  source = "./modules"

  github_repos   = var.vars_tf_repos
  github_token   = var.github_token
  terraform      = true
  tfc_token      = var.tfc_token
  oauth_token_id = tfe_oauth_client.github.oauth_token_id
}

module "tf_repo_manager" {
  source = "./modules"

  github_repos = {
    "tf_repo_manager" : {
      "description" : "Terraform Github Repository Manager",
      "tf_workspaces" : {
        "default" : {}
      }
    }
  }
  github_token   = var.github_token
  oauth_token_id = tfe_oauth_client.github.oauth_token_id
}
