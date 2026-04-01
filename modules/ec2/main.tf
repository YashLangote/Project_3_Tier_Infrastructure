resource "aws_instance" "server" {
  count                  = length(var.subnet_ids)
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index]
  vpc_security_group_ids = [var.security_group_id]
  user_data              = var.user_data_script

  tags = {
    Name = "${var.server_name}-${count.index + 1}"
  }
}