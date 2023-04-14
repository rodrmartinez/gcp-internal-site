resource "google_compute_region_ssl_certificate" "default" {
  name        = var.name
  project     = var.project
  region      = var.region
  private_key = file(var.private_key_path)
  certificate = file(var.certificate_path)

  lifecycle {
    create_before_destroy = true
  }
}