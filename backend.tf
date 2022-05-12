terraform {
  // Enabled so we can have optionals in our objects,
  // see: https://github.com/hashicorp/terraform/issues/19898
  // experiments = [module_variable_optional_attrs]
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
  backend "remote" {
    organization = "Stromweld"
    workspaces {
      name = "tf-repo-manager"
    }
  }
}
