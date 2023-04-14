# forwarding rule
resource "google_compute_forwarding_rule" "google_compute_forwarding_rule" {
  project               = var.project
  name                  = "l7-ilb-forwarding-rule"
  provider              = google-beta
  region                = var.region
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = "443"
  target                = google_compute_region_target_https_proxy.default.id
  network               = var.network
  subnetwork            = var.subnetwork
  network_tier          = "PREMIUM"
}

# Regional target HTTPS proxy
resource "google_compute_region_target_https_proxy" "default" {
  project          = var.project
  name             = "l7-ilb-target-https-proxy"
  region           = var.region
  url_map          = google_compute_region_url_map.https_lb.id
  ssl_certificates = var.certificates
}

# Regional URL map
resource "google_compute_region_url_map" "https_lb" {
  project         = var.project
  name            = "l7-ilb-regional-url-map"
  region          = var.region
  default_service = google_compute_region_backend_service.default.id
}

# Regional backend service
resource "google_compute_region_backend_service" "default" {
  project               = var.project
  name                  = "l7-ilb-backend-service"
  region                = var.region
  protocol              = "HTTP"
  port_name             = "http-server"
  load_balancing_scheme = "INTERNAL_MANAGED"
  timeout_sec           = 10
  health_checks         = [google_compute_region_health_check.default.id]
  backend {
    group           = var.group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

resource "google_compute_region_health_check" "default" {
  project = var.project
  name   = "l7-ilb-hc"
  region = var.region
  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

