variable "gcp_services_to_enable" {
  description = "List of GCP APIs to enable."
  type        = list(string)
  default     = [
    "compute.googleapis.com",
    "storage.googleapis.com",
  ]
}

resource "google_project_service" "enabled_services" {
  for_each = toset(var.gcp_services_to_enable)
  project  = google_project.this.id
  service  = each.value
  disable_on_destroy = false
}
