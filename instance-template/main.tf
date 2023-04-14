resource "google_compute_instance_template" "default" {
  project     = var.project
  name        = var.name
  description = var.description

  tags = var.tags

  labels = {
    environment = var.labels_environment
  }

  instance_description = var.instance_description
  machine_type         = var.machine_type
  can_ip_forward       = var.can_ip_forward

  scheduling {
    automatic_restart   = var.scheduling_automatic_restart
    on_host_maintenance = var.scheduling_on_host_maintenance
  }

  // Create a new boot disk from an image
  disk {
    source_image      = var.disk_source_image
    auto_delete       = var.disk_auto_delete
    boot              = var.disk_boot
    // backup the disk every day
    resource_policies = var.disk_resource_policies
  }
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.service_account
    scopes = var.service_account_scopes
  }

  metadata_startup_script = var.metadata_startup_script

  network_interface {
    network = var.network_interface
  
  }

  metadata = {
    enable-oslogin = var.enable_oslogin
 
  }

}

