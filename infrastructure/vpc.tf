

resource "aws_security_group" "infra" {
  name        = "${local.name}-allow-jenkins"
  description = "Allow Jenkins inbound traffic"
  vpc_id      = local.vpc_id
  ingress {
    description = "TCP from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }
  ingress {
    description = "TCP from VPC"
    from_port   = 30000
    to_port     = 30000
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }
  ingress {
    description = "TCP from VPC"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }
  ingress {
    description = "TCP from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}