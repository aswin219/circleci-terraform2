#Security Group for EC2 instance
resource "aws_security_group" "Security_group_instance" {
  name        = "sgrp"
  description = "ssh and http"


  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = []
      prefix_list_ids  = []
      self             = false


    },

    {
      description      = "http from VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = []
      prefix_list_ids  = []
      self             = false


    }
  ]

  egress = [
    {
      description      = "Outbound rules"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = []
      prefix_list_ids  = []
      self             = false

    }
  ]

  tags = {
    Name = "sgrp"
  }
}


#EC2 instance-1
resource "aws_instance" "ec2" {
  ami           = "ami-083654bd07b5da81d"
  instance_type = "t2.micro"
  key_name = "mykey"

  tags = {
    Name = "ec2"
  }
  user_data       = <<EOF
#! /bin/bash
sudo apt-get update -y
sudo apt install nginx -y
echo "<h1>ec2</h1>" | sudo tee /var/www/html/index.html
sudo systemctl restart nginx
EOF
  security_groups = ["${aws_security_group.Security_group_instance.name}"]
}
