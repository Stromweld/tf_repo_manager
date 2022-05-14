# terraform-github-repository

Repository management for the Sous-Chefs GitHub organisation.

## Usage

To create a new repository add it to the list of repository objects inside `terraform.tfvars.json`

There are 4 repository types we have:

- `cookbook`
- `ide`
- `terraform`
- `other`

These repository objects have a number of properties available which can be used:

| property| description | repository_types used by|
|---|---|---|
| `name` | the name of the repository | all |
| `repo_type` | the type of repository as per above list | all |
| `supermarket_name_override`| If the supermarket name of the cookbook is not the same as the repository name | `cookbook` |
| `description_override` | Used to override the description. | `ide`, `terraform`, `other` |
| `additional_topics` | Used to add additional topics to the repository | all |
| `additional_status_checks` | Used to add additional required status checks to the repository | all |
| `projects_enabled` | Used to enable projects on the repository | all |

## Importing a repository (Board only)

Note: **Board Members only**
Add repository to `terraform.tfvars.json`
import the state file using:

```bash
terraform import module.repository[\"bot-trainer\"].github_repository.this bot-trainer
terraform import module.repository[\"bot-trainer\"].github_branch.default bot-trainer:main
terraform import module.repository[\"bot-trainer\"].github_branch_protection.default bot-trainer:main
```
