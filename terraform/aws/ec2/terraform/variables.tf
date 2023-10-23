variable "instance_name" {
  description = "Value of Name tag for EC2 instance"
  type        = string
  default     = "ApiServer"
}

variable "ec2_public_key" {
  description = "SSH pubic key to add to EC2 instance known_hosts"
  type        = string
}
