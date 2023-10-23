output "instance_name" {
  description = "Name of EC2 instance"
  value       = aws_instance.api_server.tags.Name
}

output "instance_id" {
  description = "ID of EC2 instance"
  value       = aws_instance.api_server.id
}

output "instance_public_ip" {
  description = "Public IP address of EC2 instance"
  value       = aws_instance.api_server.public_ip
}
