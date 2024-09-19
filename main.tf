# Configure the Vercel provider
terraform {
  required_providers {
    vercel = {
      source  = "vercel/vercel"
      version = "~> 0.11.4"
    }
  }
}

# Configure the Vercel provider with your Vercel API token
provider "vercel" {
  api_token = var.vercel_api_token
}

# Define variables
variable "vercel_api_token" {
  type        = string
  description = "Vercel API token"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository (format: owner/repo)"
}

variable "project_name" {
  type        = string
  description = "Name of the Vercel project"
}

# Create a new Vercel project
resource "vercel_project" "project" {
  name      = var.project_name
  framework = "angular"  # Adjust this based on your project's framework
  git_repository = {
    type = "github"
    repo = var.github_repo
  }
}

# Configure production deployment from the main branch
resource "vercel_deployment" "production" {
  project_id  = vercel_project.project.id
  ref         = "main"
  production  = true

  depends_on = [vercel_project.project]
}

# Output the deployment URL
output "production_url" {
  value = vercel_deployment.production.url
}