output "node_id" {
  value = github_repository.this.node_id
}

output "full_name" {
  value = github_repository.this.full_name
}
output "ssh_clone_url" {
  value = github_repository.this.ssh_clone_url
}

output "http_clone_url" {
  value = github_repository.this.http_clone_url
}

output "web_url" {
  value = github_repository.this.html_url
}
