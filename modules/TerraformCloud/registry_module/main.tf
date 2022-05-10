resource "tfe_registry_module" "tf_module" {
  vcs_repo {                                        # (Required) Settings for the registry module's VCS repository. Forces a new resource if changed.
    display_identifier = var.vcs_display_identifier # (Required) The display identifier for your VCS repository. For most VCS providers outside of BitBucket Cloud, this will match the identifier string.
    identifier         = var.vcs_identifier         # (Required) A reference to your VCS repository in the format <organization>/<repository> where <organization> and <repository> refer to the organization (or project key, for Bitbucket Server) and repository in your VCS provider. The format for Azure DevOps is //_git/.
    oauth_token_id     = var.oauth_token_id         # (Required) Token ID of the VCS Connection (OAuth Connection Token) to use.
  }
}
