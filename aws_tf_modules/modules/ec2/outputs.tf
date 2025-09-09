output "instance_id" {
  value = aws_instance.my-host.id
}

output "instance_public_ip" {
  value = aws_instance.my-host.public_ip
}

