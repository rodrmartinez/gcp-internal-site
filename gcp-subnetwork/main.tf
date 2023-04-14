resource "google_compute_subnetwork" "proxy-only_subnetwork" {
  provider      = google-beta
  project       = var.project
  name          = var.name
  ip_cidr_range = var.ip_cidr_range
  region        = var.region
  purpose       = var.purpose
  role          = var.role
  network       = var.network
}