variable "github_token" {
  type        = string
  default     = null
  description = "List of Collaborators to add to repository"
}
variable "oauth_token_id" {
  type    = string
  default = null
}
variable "tfc_token" {
  type        = string
  default     = null
  description = "Terraform Cloud access token"
  sensitive   = true
}
variable "supermarket_key" {
  type        = string
  default     = null
  description = "Chef Supermarket User pem key"
  sensitive   = true
}
variable "github_repos" {
  type        = any
  description = "GitHub repositories to create"
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
