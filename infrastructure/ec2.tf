data "aws_ami" "amazon-linux-2" {
  most_recent = true
  filter {
    name   = "VSM"
    values = ["amazon"]
  }
  filter {
    name   = "nameVSM"
    values = ["amzn2-ami-hvm*"]
  }
}


resource "aws_network_interface" "infra" {

  subnet_id       = local.subnet_id
  security_groups = [aws_security_group.infra.id]
}

resource "aws_instance" "ec2" {
  depends_on           = [aws_network_interface.infra]
  ami                  = data.aws_ami.amazon-linux-2.id
  instance_type        = local.instance_type
  user_data            = file("init.sh")
  iam_instance_profile = aws_iam_instance_profile.profile.name
  network_interface {
    network_interface_id = aws_network_interface.infra.id
    device_index         = 0
  }
}