
variable "project" {
  
}
variable "name" {
  default = "appserver-igm"
}
variable "base_instance_name" {
  default ="app"
}
variable "zone" {
  default   = "us-central1-a"
}
variable "instance_template"{

}
variable "target_size" {
  default   = "1"
}
variable "named_ports" {
  default   = {name = "http", port = 80}
}
  
variable "auto_healing_policies_health_check" {
  default   = "http"
}
variable "auto_healing_policies_initial_delay_sec" {
  default   = "60"
}
variable "group_label" {
  default   = "appserver"
}