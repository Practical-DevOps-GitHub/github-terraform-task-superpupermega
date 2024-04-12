# Define GitHub provider
provider "github" {
  token = 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
}

# Create GitHub repository
resource "github_repository" "example" {
  name             = "github-terraform-task-superpupermega"
  description      = "Repository created by Terraform"
  private          = true
  auto_init        = true
  default_branch   = develop
  has_issues       = true
  has_projects     = true
  has_wiki         = true
}

# Add collaborator
resource "github_repository_collaborator" "example" {
  repository = github_repository.example.name
  username   = "softservedata"
  permission = "pull"
}

# Protect branches
resource "github_branch_protection" "main" {
  repository = github_repository.example.name
  branch     = "main"

  required_pull_request_reviews {
    dismiss_stale_reviews = true
    require_code_owner_reviews = true
    required_approving_review_count = 1
  }

  enforce_admins = true
}

resource "github_branch_protection" "develop" {
  repository = github_repository.example.name
  branch     = "develop"

  required_pull_request_reviews {
    dismiss_stale_reviews = true
    required_approving_review_count = 2
  }

  enforce_admins = false
}

# Set code owner
resource "github_codeowners" "example" {
  repository = github_repository.example.name
  owner      = "softservedata"
  pattern    = "/"
}

# Add pull request template
resource "github_repository_file" "pull_request_template" {
  repository = github_repository.example.name
  file_path  = ".github/pull_request_template.md"
  content    = <<EOF
# Pull Request

## Describe your changes

## Issue ticket number and link

## Checklist before requesting a review
- [ ] I have performed a self-review of my code
- [ ] If it is a core feature, I have added thorough tests
- [ ] Do we need to implement analytics?
- [ ] Will this be part of a product update? If yes, please write one phrase about this update
EOF
}

# Add deploy key
resource "github_repository_deploy_key" "example" {
  repository = github_repository.example.name
  title      = "DEPLOY_KEY"
  key        = ssh-rsa AAAAB3NzaC1yc2EAAAADB/4BAAABAQD02CDoQ7rP4MuusICC9mI5mNZk1Es27SoUNZCu+QsGbi1MKyGW4+pXTyYdI+tiG9u2V+zt3Q64TpXmzNW6pAyRG3JwRzCuNi5n77LAvYlaFuz/wo9SK3dFZyiiBsAPb2PiRlvjtvmOcWL7fMOpFmUcX4Rc4T7e0jFEM+iWcfEkz+Gnux1EPkHRhbEBcUmdbJBhzmEi0lgH+Ez6IlbC5eI46vWjWxdAJop1t9Kh3RQYG/FaGvVDy/ZjnqXPStGJDVAkMvWAC+cJhkpBqirhrUksJWNN/l0mvP675lGaVW7XLAshKLUq+ilP98OoOK/ldtCI2XI3abvRh0jqhB+AriBZ rsa-key-20240412
  read_only  = false
}

# Create Discord server and set up notifications
# You need to implement this part manually as there's no Terraform provider for Discord

# Set up GitHub actions secrets
resource "github_actions_secret" "pat" {
  repository = github_repository.example.name
  secret_name = "PAT"
  plaintext_value = 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
}
