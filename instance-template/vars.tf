variable "project" {
  
}
variable "name" {
  default = "default"
}
variable "description" {
  default = "Default instance template"
}
variable "tags" {
  default = []
}
variable "labels_environment" {
  default = "default"
}
variable "instance_description" {
  default = "Default instance"
}
variable "machine_type" {
  default = "n1-standard-1"
}
variable "can_ip_forward" {
  default = false
}
variable "scheduling_automatic_restart" {
  default = true
}
variable "scheduling_on_host_maintenance" {
  default = "MIGRATE"
}
variable "disk_source_image" {
  default = "debian-cloud/debian-11"
}
variable "disk_auto_delete" {
  default = true
}
variable "disk_boot" {
  default = true
}
variable "disk_resource_policies" {
  default = []
}
variable "disk_source" {
  default = "existing-disk"
}
variable "metadata_startup_script" {
  default = ""
}
variable "network_interface" {
  default = "default"
}
  
variable "enable_oslogin" {
  default = "TRUE"
}
variable "service_account" {
  
}
variable "service_account_scopes" {
  default =  ["cloud-platform"]
}