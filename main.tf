resource "google_service_account" "this" {
  account_id   = var.stack_name
  display_name = var.stack_name
}

# resource "google_compute_disk" "this" {
#   name    = var.stack_name
#   zone    = var.google_cloud_region
#   type    = "hyperdisk-balanced"
#   size    =  1000
#   provisioned_iops = 3500 
#   provisioned_throughput = 125
# }

resource "google_compute_instance" "this" {
  name         = var.stack_name
  machine_type = "c4d-standard-4"
  zone         = "asia-southeast1-a" # will need to set this so iap command will work

  tags         = ["allow-health-check"]

  boot_disk {
    auto_delete = false
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2504-amd64"
      size = 100
      provisioned_iops = 3000
      provisioned_throughput = 200
    }
  }

  network_interface {
    network =  module.vpc.network_id
    subnetwork = google_compute_subnetwork.this.id
    network_ip = "10.1.0.6" # needs to be static for ssh command to work 
  }

  lifecycle {
    create_before_destroy = false
  }
  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

#   attached_disk {
#     source      = google_compute_disk.this.self_link
#     device_name = "hyperdisk"
#   }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.this.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_compute_resource_policy" "weekday_schedule" {
  name        = "weekday-work-hours-policy"
  region      = "asia-southeast1"
  description = "Starts instances at 7am and stops them at 7pm on weekdays."

  instance_schedule_policy {
    vm_start_schedule {
      # Starts at 7:00 AM on Monday through Friday
      schedule = "0 7 * * 1-5"
    }
    vm_stop_schedule {
      # Stops at 7:00 PM (19:00) on Monday through Friday
      schedule = "0 19 * * 1-5"
    }
    time_zone = "Asia/Singapore"
  }
}
