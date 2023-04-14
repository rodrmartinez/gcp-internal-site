resource "google_compute_health_check" "autohealing" {
  project = var.project
  name                = var.name
  check_interval_sec  = var.check_interval_sec
  timeout_sec         = var.timeout_sec
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold

  tcp_health_check {
    port = var.tcp_health_check_port
  }
}