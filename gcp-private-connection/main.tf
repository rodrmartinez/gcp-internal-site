resource "google_compute_global_address" "private_ip_address" {
  provider      = google-beta
  project       = var.project
  name          = var.global_address_name
  purpose       = var.global_address_purpose
  address_type  = var.global_address_type
  prefix_length = var.global_address_prefix_length
  network       = var.network
}


resource "google_service_networking_connection" "private_vpc_connection" {
  provider                = google-beta
  network                 = var.network
  service                 = var.service
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}