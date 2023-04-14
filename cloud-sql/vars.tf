variable "project" {
  
}
variable "name" {
  default = "appserver-db"
}
variable "database_version" {
  default = "POSTGRES_14"
}
variable "region" {
 default =  "us-central1"
}
variable "tier" {
  default = "db-f1-micro"
}
variable "authorized_network_name" {
  default = "default"
}
variable "authorized_network_value" {
  default = "0.0.0.0/0"
  
}
variable "ipv4_enabled" {
  default = true
}
variable "private_network" {

}

variable "user_name" {
  default = "postgres"
}
variable "user_password" {
  default = "postgres"
}
variable "database_name" {
  
}