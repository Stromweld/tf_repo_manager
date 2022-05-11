locals {
  chef_description      = var.cookbook ? "Development repository for the ${var.name} Chef Cookbook" : ""
  tf_module_description = var.tf_module ? "Development repository for the ${var.name} Terraform Module" : ""
  terraform_description = var.terraform ? "Configuration repository for the ${var.name} Terraform code" : ""
  description           = var.description == null ? join("", [local.chef_description, local.terraform_description, local.tf_module_description]) : var.description
  gitignore_template    = var.gitignore_template == null ? (var.cookbook ? "ChefCookbook" : (var.terraform || var.tf_module ? "Terraform" : null)) : var.gitignore_template
  topics = distinct(
    compact(
      concat(
        ["managed-by-terraform"],
        var.cookbook ? [
          "chef",
          "chef-cookbook",
          "chef-resource",
        ] : [],
        var.terraform || var.tf_module ? [
          "terraform"
        ] : [],
        var.topics
      )
    )
  )
}

data "github_user" "Stromweld" {
  username = "Stromweld"
}

resource "github_repository" "this" {
  name                   = var.name                 # (Required) The name of the repository.
  description            = local.description        # (Optional) A description of the repository.
  homepage_url           = null                     # (Optional) URL of a page describing the project.
  visibility             = var.visibility           # (Optional) Can be public or private. If your organization is associated with an enterprise account using GitHub Enterprise Cloud or GitHub Enterprise Server 2.20+, visibility can also be internal. The visibility parameter overrides the private parameter.
  has_issues             = true                     # (Optional) Set to true to enable the GitHub Issues features on the repository.
  has_projects           = false                    # (Optional) Set to true to enable the GitHub Projects features on the repository. Per the GitHub documentation when in an organization that has disabled repository projects it will default to false and will otherwise default to true. If you specify true when it has been disabled it will return an error.
  has_wiki               = false                    # (Optional) Set to true to enable the GitHub Wiki features on the repository.
  is_template            = var.is_template          # (Optional) Set to true to tell GitHub that this is a template repository.
  allow_merge_commit     = false                    # (Optional) Set to false to disable merge commits on the repository.
  allow_squash_merge     = true                     # (Optional) Set to false to disable squash merges on the repository.
  allow_rebase_merge     = false                    # (Optional) Set to false to disable rebase merges on the repository.
  allow_auto_merge       = true                     # (Optional) Set to true to allow auto-merging pull requests on the repository.
  delete_branch_on_merge = true                     # (Optional) Automatically delete head branch after a pull request is merged. Defaults to false.
  has_downloads          = false                    # (Optional) Set to true to enable the (deprecated) downloads features on the repository.
  auto_init              = true                     # (Optional) Set to true to produce an initial commit in the repository.
  gitignore_template     = local.gitignore_template # (Optional) Use the name of the template without the extension. For example, "Haskell".
  license_template       = "apache-2.0"             # (Optional) Use the name of the template without the extension. For example, "mit" or "mpl-2.0".
  archived               = var.archived             # (Optional) Specifies if the repository should be archived. Defaults to false. NOTE Currently, the API does not support unarchiving.
  archive_on_destroy     = true                     # (Optional) Set to true to archive the repository instead of deleting on destroy.
  dynamic "pages" {                                 # (Optional) The repository's GitHub Pages configuration. See GitHub Pages Configuration below for details.
    for_each = var.pages
    content {
      dynamic "source" { # (Required) The source branch and directory for the rendered Pages site. See GitHub Pages Source below for details.
        for_each = pages.value.source
        content {
          branch = source.value.branch          # (Required) The repository branch used to publish the site's source files. (i.e. main or gh-pages.
          path   = try(source.value.path, null) # (Optional) The repository directory from which the site publishes (Default: /).
        }
      }
      cname = try(pages.value.cname, null) # (Optional) The custom domain for the repository. This can only be set after the repository has been created.
    }
  }
  topics = local.topics # (Optional) The list of topics of the repository.
  dynamic "template" {  # (Optional) Use a template repository to create this resource. See Template Repositories below for details.
    for_each = var.template
    content {
      owner      = template.value.owner      # (Required) The GitHub organization or user the template repository is owned by.
      repository = template.value.repository # (Required) The name of the template repository.
    }
  }
  vulnerability_alerts                    = true # (Optional) - Set to true to enable security alerts for vulnerable dependencies. Enabling requires alerts to be enabled on the owner level. (Note for importing: GitHub enables the alerts on public repos but disables them on private repos by default.) See GitHub Documentation for details. Note that vulnerability alerts have not been successfully tested on any GitHub Enterprise instance and may be unavailable in those settings.
  ignore_vulnerability_alerts_during_read = null # (Optional) - Set to true to not call the vulnerability alerts endpoint so the resource can also be used without admin permissions during read.
}

resource "github_branch" "this" {
  repository    = github_repository.this.name # (Required) The GitHub repository name.
  branch        = "main"                      # (Required) The repository branch to create.
  source_branch = null                        # (Optional) The branch name to start from. Defaults to main.
  source_sha    = null                        # (Optional) The commit hash to start from. Defaults to the tip of source_branch. If provided, source_branch is ignored.
}

resource "github_branch_default" "this" {
  repository = github_repository.this.name # (Required) The GitHub repository
  branch     = github_branch.this.branch   # (Required) The branch (e.g. main)
}

resource "github_branch_protection" "default" {
  # when a repo is being initialized/created you can run into race conditions
  # by adding an explicit depends we force the repo to be created
  # before it attempts to add branch protection
  depends_on = [
    github_repository.this,
  ]

  repository_id                   = github_repository.this.node_id # (Required) The name or node ID of the repository associated with this branch protection rule.
  pattern                         = github_branch.this.branch      # (Required) Identifies the protection rule pattern.
  enforce_admins                  = true                           # (Optional) Boolean, setting this to true enforces status checks for repository administrators.
  require_signed_commits          = false                          # (Optional) Boolean, setting this to true requires all commits to be signed with GPG.
  required_linear_history         = false                          # (Optional) Boolean, setting this to true enforces a linear commit Git history, which prevents anyone from pushing merge commits to a branch
  require_conversation_resolution = true                           # (Optional) Boolean, setting this to true requires all conversations on code must be resolved before a pull request can be merged.
  required_status_checks {                                         # (Optional) Enforce restrictions for required status checks. See Required Status Checks below for details.
    strict = true                                                  # (Optional) Require branches to be up to date before merging. Defaults to false.
    contexts = distinct(                                           # (Optional) The list of status checks to require in order to merge into this branch. No status checks are required by default.
      compact(
        concat(
          [
            "linting / linters",
          ],
          var.cookbook ? [
            "lint / cookstyle",
            "Changelog Validator",
            "Metadata Version Validator",
            "Release Label Validator"
          ] : [],
          var.terraform || var.tf_module ? [
            "terraform / terraform"
          ] : []
        )
      )
    )
  }
  required_pull_request_reviews {           # (Optional) Enforce restrictions for pull request reviews. See Required Pull Request Reviews below for details.
    dismiss_stale_reviews           = true  # (Optional) Dismiss approved reviews automatically when a new commit is pushed. Defaults to false.
    restrict_dismissals             = false # (Optional) Restrict pull request review dismissals.
    dismissal_restrictions          = null  # (Optional) The list of actor IDs with dismissal access. If not empty, restrict_dismissals is ignored.
    pull_request_bypassers          = null  # (Optional) The list of actor IDs that are allowed to bypass pull request requirements.
    require_code_owner_reviews      = null  # (Optional) Require an approved review in pull requests including files with a designated code owner. Defaults to false.
    required_approving_review_count = null  # (Optional) Require x number of approvals to satisfy branch protection requirements. If this is specified it must be a number between 0-6. This requirement matches GitHub's API, see the upstream documentation for more information.
  }
  push_restrictions   = null  # (Optional) The list of actor IDs that may push to the branch.
  allows_deletions    = false # (Optional) Boolean, setting this to true to allow the branch to be deleted.
  allows_force_pushes = false # (Optional) Boolean, setting this to true to allow force pushes on the branch.
}

resource "github_repository_collaborator" "this" {
  for_each = toset(var.github_repository_collaborators)

  repository                  = github_repository.this.name # (Required) The GitHub repository
  username                    = each.value                  # (Required) The user to add to the repository as a collaborator.
  permission                  = "push"                      # (Optional) The permission of the outside collaborator for the repository. Must be one of pull, push, maintain, triage or admin for organization-owned repositories. Must be push for personal repositories. Defaults to push.
  permission_diff_suppression = null                        # (Optional) Suppress plan diffs for triage and maintain. Defaults to false.
}
