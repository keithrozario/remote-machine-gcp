module vpc {
    depends_on = [ google_project_service.enabled_services ]
    source = "./vpc"
    network_name = "${var.stack_name}"
    region = var.google_cloud_region
}

resource google_compute_subnetwork "this" {
    name = "${var.google_cloud_region}-${var.stack_name}"
    ip_cidr_range = "10.1.0.0/16"
    region = var.google_cloud_region
    network = module.vpc.network_id
    private_ip_google_access = true
    log_config {
      aggregation_interval = "INTERVAL_30_SEC"
      flow_sampling = 1.0
      metadata = "INCLUDE_ALL_METADATA"
    }
}
