output "servers" {
  value = ["${aws_instance.server.*.public_ip}"]
}
