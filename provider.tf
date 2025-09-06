
# Backend is in a separate project
terraform {
  backend "gcs" {
    bucket = "tf-backends-krozario-gcloud"
    prefix = "terraform/state/remote-machine"
  }
  required_providers {
    google-beta = {
      source = "hashicorp/google-beta"
      version = "6.32.0"
    }
    google = {
      source = "hashicorp/google"
      version = "6.32.0"
    }
  }
}

provider "google" {
  alias = "google_project_creation"
  region  = var.google_cloud_region
}
resource "random_id" "project_id_suffix" {
  byte_length = 4
}
resource "google_project" "this" {
  provider = google.google_project_creation
  name       = "Remote Machine"
  project_id = "${var.stack_name}-${random_id.project_id_suffix.hex}"
  billing_account = "01E0F1-FD75BB-40DE54"
}


provider "google-beta" {
  region  = var.google_cloud_region
  project = google_project.this.project_id
}
provider "google" {
  region  = var.google_cloud_region
  project = google_project.this.project_id
}

data "google_client_config" "this" {
  provider = google
}