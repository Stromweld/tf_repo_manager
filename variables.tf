variable "github_token" {
  type        = string
  description = "Token to authenticate to github"
  sensitive   = true
}
variable "tfc_token" {
  type        = string
  description = "Token to authenticate to TFC"
  sensitive   = true
}
variable "vars_chef_cb_repos" {
  type        = any
  description = "The Chef Cookbook repositories to create."
}
variable "vars_other_repos" {
  type        = any
  description = "The repositories to create."
}
variable "vars_tf_module_repos" {
  type        = any
  description = "The Terraform Module repositories to create."
}
variable "vars_tf_repos" {
  type        = any
  description = "The Terraform repositories to create."
}
