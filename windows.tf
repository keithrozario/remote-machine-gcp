resource "google_compute_instance" "windows" {
  name         = "${var.stack_name}-windows"
  machine_type = "c4d-standard-4"
  zone         = "asia-southeast1-a"

  tags = ["allow-health-check", "allow-rdp"]

  boot_disk {
    auto_delete = false
    initialize_params {
      image                  = "windows-cloud/windows-2022"
      size                   = 1000
      provisioned_iops       = 3500
      provisioned_throughput = 200
    }
  }

  network_interface {
    network    = module.vpc.network_id
    subnetwork = google_compute_subnetwork.this.id
    network_ip = "10.1.0.7"
  }

  lifecycle {
    create_before_destroy = false
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  service_account {
    email  = google_service_account.this.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
