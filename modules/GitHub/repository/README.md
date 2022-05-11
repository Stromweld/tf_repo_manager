# repository

Terraform module for GitHub Repositories

## References

<https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository>
<https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch>
<https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default>
<https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection>
<https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborator>

## Usage

```hcl
module "example" {
  source = "./"

  name = "example"
}
```

## Inputs

| Name | Type         | Default | Required | Description |
|------|--------------|---------|----------|-------------|
| `name` | string | | yes | Name of the repository|
| `description` | string | varies by repository type | no | Description of repository contents |
| `visibility` | string | "public" | no | Allows your repository to be seen by general public or not |
| `is_template` | bool | false | no | Set to true to tell GitHub that this is a template repository |
| `gitignore_template` | string | varies by repository type | no | Set gitignore file based on template |
| `archived` | bool | null | no | Specifies if the repository should be archived |
| `pages` | object({source = object({branch = string, path = optional(string)}) cname = optional(string)})| {} | no | GitHub Pages configuration |
| `topics` | list(string) | varies by repository type | no | The list of topics of the repository |
| `template` | object({owner = string, repository = string}) | {} | no | Create repository from template repository |
| `cookbook` | bool | false | no | Enables Chef Cookbook features |
| `terraform` | bool | false | no | Enables Terraform features |
| `tf_module` | bool | false | no | Enables Terraform Module features |
| `github_repository_collaborators` | list(string) | [] | no | List of Collaborators to add to repository |

## Outputs

| Name            | Description              |
|-----------------|--------------------------|
