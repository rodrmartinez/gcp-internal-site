variable "project" {
}
variable "name" {
  default   = "autohealing"
}
variable "check_interval_sec" {
  default   = 5
}
variable "healthy_threshold" {
  default   = 2
}
variable "timeout_sec" {
  default   = 5
}
variable "unhealthy_threshold" {
  default   = 2
}
variable "tcp_health_check_port" {
  default   = "80"
}