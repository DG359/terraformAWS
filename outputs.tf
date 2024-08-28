output "EC2_instance_id" {
  value = data.aws_ami.myServer_ami.id
}

output "dev_ip" {
  value = aws_instance.dev_node.public_ip
}