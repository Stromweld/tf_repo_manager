resource "tfe_workspace" "workspace" {
  name                          = var.name                # (Required) Name of the workspace.
  organization                  = var.organization        # (Required) Name of the organization.
  description                   = var.description         # (Optional) A description for the workspace.
  agent_pool_id                 = null                    # (Optional) The ID of an agent pool to assign to the workspace. Requires execution_mode to be set to agent. This value must not be provided if execution_mode is set to any other value or if operations is provided.
  allow_destroy_plan            = null                    # (Optional) Whether destroy plans can be queued on the workspace.
  auto_apply                    = false                   # (Optional) Whether to automatically apply changes when a Terraform plan is successful. Defaults to false.
  execution_mode                = "remote"                # (Optional) Which execution mode to use. Using Terraform Cloud, valid values are remote, local or agent. Using Terraform Enterprise, only remote and local execution modes are valid. When set to local, the workspace will be used for state storage only. Defaults to remote. This value must not be provided if operations is provided.
  file_triggers_enabled         = null                    # (Optional) Whether to filter runs based on the changed files in a VCS push. If enabled, the working directory and trigger prefixes describe a set of paths which must contain changes for a VCS push to trigger a run. If disabled, any push will trigger a run. Defaults to true.
  global_remote_state           = null                    # (Optional) Whether the workspace allows all workspaces in the organization to access its state data during runs. If false, then only specifically approved workspaces can access its state (remote_state_consumer_ids).
  remote_state_consumer_ids     = null                    # (Optional) The set of workspace IDs set as explicit remote state consumers for the given workspace.
  queue_all_runs                = true                    # (Optional) Whether all runs should be queued. When set to false, runs triggered by a VCS change will not be queued until at least one run is manually queued. Defaults to true.
  speculative_enabled           = var.speculative_enabled # (Optional) Whether this workspace allows speculative plans. Setting this to false prevents Terraform Cloud or the Terraform Enterprise instance from running plans on pull requests, which can improve security if the VCS repository is public or includes untrusted contributors. Defaults to true.
  structured_run_output_enabled = null                    # (Optional) Whether this workspace should show output from Terraform runs using the enhanced UI when available. Defaults to true. Setting this to false ensures that all runs in this workspace will display their output as text logs.
  ssh_key_id                    = null                    # (Optional) The ID of an SSH key to assign to the workspace.
  terraform_version             = "1.2.0"                 # (Optional) The version of Terraform to use for this workspace. Defaults to the latest available version.
  trigger_prefixes              = null                    # (Optional) List of repository-root-relative paths which describe all locations to be tracked for changes.
  tag_names                     = null                    # (Optional) A list of tag names for this workspace.
  working_directory             = null                    # (Optional) A relative path that Terraform will execute within. Defaults to the root of your repository.
  dynamic "vcs_repo" {                                    # (Optional) Settings for the workspace's VCS repository, enabling the UI/VCS-driven run workflow. Omit this argument to utilize the CLI-driven and API-driven workflows, where runs are not driven by webhooks on your VCS provider.
    for_each = var.vcs_repo["enabled"] ? { vcs_settings = var.vcs_repo } : {}
    content {
      identifier         = var.repo_identifier                              # (Required) A reference to your VCS repository in the format :org/:repo where :org and :repo refer to the organization and repository in your VCS provider.
      branch             = try(vcs_repo.value["branch"], "main")            # (Optional) The repository branch that Terraform will execute from. Default to main.
      ingress_submodules = try(vcs_repo.value["ingress_submodules"], false) # (Optional) Whether submodules should be fetched when cloning the VCS repository. Defaults to false.
      oauth_token_id     = var.oauth_token_id                               # (Required) Token ID of the VCS Connection (OAuth Connection Token) to use.
    }
  }
  // lifecycle { prevent_destroy = true }
}
