variable "name" {
  type        = string
  description = "Repository Name"
}
variable "repo_config" {
  type        = any
  description = "Config map of Github repo attributes"
}
variable "tf_workspaces" {
  type        = any
  default     = {}
  description = ""
}
variable "github_token" {
  type        = string
  default     = null
  description = "List of Collaborators to add to repository"
}
variable "oauth_token_id" {
  type        = string
  default     = null
  description = "TF VCS oauth token ID"
}
variable "cookbook" {
  type        = bool
  default     = false
  description = "Enables Chef Cookbook features"
}
variable "terraform" {
  type        = bool
  default     = false
  description = "Enables Terraform features"
}
variable "tf_module" {
  type        = bool
  default     = false
  description = "Enables Terraform Module features"
}
