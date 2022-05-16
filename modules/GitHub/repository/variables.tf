variable "name" {
  type        = string
  description = "Name of the repository"
}
variable "description" {
  type        = string
  default     = null
  description = "Description of repository contents"
}
variable "visibility" {
  type    = string
  default = "public"
  validation {
    condition     = can(regex("^public|private$", var.visibility))
    error_message = "Can be public or private."
  }
  description = "Allows your repository to be seen by general public or not"
}
variable "is_template" {
  type        = bool
  default     = false
  description = "Set to true to tell GitHub that this is a template repository."
}
variable "gitignore_template" {
  type    = string
  default = null
}
variable "archived" {
  type        = bool
  default     = null
  description = "Specifies if the repository should be archived."
}
variable "pages" {
  type        = any
  default     = {}
  description = "GitHub Pages configuration"
}
variable "topics" {
  type        = list(string)
  default     = []
  description = "The list of topics of the repository"
}
variable "template" {
  type        = any
  default     = {}
  description = "Create repository from template repository"
}
variable "github_repository_collaborators" {
  type        = list(string)
  default     = []
  description = "List of Collaborators to add to repository"
}
variable "github_branch" {
  type        = map(string)
  default     = {}
  description = "Map of additional branches to create"
}
variable "github_branch_protection" {
  type    = map(any)
  default = { main = {} }
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
