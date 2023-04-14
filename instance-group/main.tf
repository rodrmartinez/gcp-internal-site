resource "google_compute_instance_group_manager" "appserver" {
  provider = google-beta
  project = var.project
  name = var.name

  base_instance_name = var.base_instance_name
  zone               = var.zone
  target_size        = var.target_size
  version {
    instance_template  = var.instance_template
  }

  dynamic "named_port" {
    for_each = var.named_ports
    content {
      name = named_port.value.name
      port = named_port.value.port
    }
  }

  auto_healing_policies {
    health_check      = var.auto_healing_policies_health_check
    initial_delay_sec = var.auto_healing_policies_initial_delay_sec
  }

}
