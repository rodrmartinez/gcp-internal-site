output "instance_group" {
  description = "The id of the load balancer."
  value       = google_compute_instance_group_manager.appserver.instance_group
}