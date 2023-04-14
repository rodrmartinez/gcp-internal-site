data "google_client_openid_userinfo" "me" {
}

data "google_compute_network" "default" {
  project = var.project
  name    = "default"
}

data "google_compute_subnetwork" "default"{
  project = var.project
  name    = "default"
  region  = var.region
}

# ------------------------------------------------------------------------------
# Cloud NAT
# ------------------------------------------------------------------------------

module "cloud-nat"{
  source          = "./cloud-nat"
  project         = var.project
  router_name     = "website-router"
  router_nat_name = "website-nat"
  network         = data.google_compute_network.default.id
  region          = var.region
  depends_on      = [module.private-vpc-connection]
}

# ------------------------------------------------------------------------------
# Create a  private connection between the VPC network and a network owned by Google
# ------------------------------------------------------------------------------

module "private-vpc-connection" {
  source              = "./gcp-private-connection"
  project             = var.project
  global_address_name = "private-ip-address"
  network             = data.google_compute_network.default.id
  service             = "servicenetworking.googleapis.com"
}

# ------------------------------------------------------------------------------
# Cloud SQL instance with internal IP address
# ------------------------------------------------------------------------------

module "website-db"{
  source          = "./cloud-sql"
  project         = var.project
  name            = "website-db"
  private_network = module.private-vpc-connection.network
  ipv4_enabled    = false
  user_name       = var.db_user
  user_password   = var.db_password
  database_name   = "website_test"
  depends_on      = [module.private-vpc-connection]
}

# ------------------------------------------------------------------------------
#  Instance Template
# ------------------------------------------------------------------------------

module "instance-template" {
  source                  = "./instance-template"
  project                 = var.project
  metadata_startup_script = templatefile("${path.module}/startup-script", {
                            db_user     = var.db_user
                            db_password = var.db_password
                            db_host     = module.website-db.ip_address
                            db_name     = var.db_name
                          })
  machine_type            = "e2-medium"
  enable_oslogin          = "TRUE"
  service_account         = var.service_account
  service_account_scopes  = [ "cloud-platform"]
  tags                    = ["http-server"]
}

# ------------------------------------------------------------------------------
#  Instance Group
# ------------------------------------------------------------------------------

module "website-instance-group" {
  source                             = "./instance-group" 
  project                            = var.project
  auto_healing_policies_health_check = module.http-health-check.id
  instance_template                  = module.instance-template.id
  named_ports                        = var.website_ports
  target_size                        = "1"
  name                               = "webiste-igm"
  base_instance_name                 = "website"
}

# ------------------------------------------------------------------------------
#  HTTP Port Health Check
# ------------------------------------------------------------------------------

module "http-health-check" {
  source                = "./health-check"
  name                  = "http-health-check"
  project               = var.project
  tcp_health_check_port =  80
  unhealthy_threshold   = 5
}

# ------------------------------------------------------------------------------
# GCP Region SSL Certificate
# ------------------------------------------------------------------------------

module "website-cert" {
  source           = "./gcp-region-ssl-certificate"
  name             = "website-cert"
  project          = var.project
  region           = var.region
  private_key_path = "/etc/ssl/private/selfsigned.key"
  certificate_path = "/etc/ssl/certs/selfsigned.crt"
}

# Proxy Only Subnetwork for Envoy-Proxy

module "proxy-only-subnetwork" {
  source        = "./gcp-subnetwork"
  name          = "proxy-only"
  project       = var.project
  ip_cidr_range = "10.1.0.0/23"
  region        = var.region
  purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
  role          = "ACTIVE"
  network       = data.google_compute_network.default.id
}

# ------------------------------------------------------------------------------
#  Internal Load Balancer
# ------------------------------------------------------------------------------

module "internal-lb" {
  source       = "./internal-lb"
  region       = var.region
  project      = var.project
  group        = module.website-instance-group.instance_group
  network      = data.google_compute_network.default.id
  subnetwork   = data.google_compute_subnetwork.default.id
  certificates = [module.website-cert.name]
  depends_on   = [    module.website-cert  ]
}
