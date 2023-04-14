resource "google_sql_database_instance" "main" {
  project          = var.project
  name             = var.name
  database_version = var.database_version
  region           = var.region

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = var.tier
  
    ip_configuration {
        authorized_networks {
            name  = var.authorized_network_name
            value = var.authorized_network_value
        }
        ipv4_enabled = var.ipv4_enabled
        private_network = var.private_network
        
    }
  }
}

resource "google_sql_user" "users" {
  project = var.project
  name     = var.user_name
  instance = google_sql_database_instance.main.name
  password = var.user_password
}

resource "google_sql_database" "database" {
  project = var.project
  name     = var.database_name
  instance = google_sql_database_instance.main.name
}