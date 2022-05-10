variable "name" {
  type = string
}
variable "description" {
  type    = string
  default = null
}
variable "organization" {
  type    = string
  default = "Stromweld"
}
variable "vcs_repo" {
  type = map(string)
  default = {
    enabled = false
  }
}
variable "repo_identifier" {
  type    = string
  default = null
}
variable "oauth_token_id" {
  type    = string
  default = null
}
variable "speculative_enabled" {
  type    = bool
  default = true
}
