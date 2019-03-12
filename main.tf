data "aws_availability_zones" "all" {} #a list of the availibility_zones this account has

resource "aws_security_group" "k8m" { #network security group for ec2 instance
  name = "k8m_sg"
  ingress { //everything
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress { #outbound rules
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "k8m" {
  ami = "ami-18726478" //rhel 7.5
  instance_type = "t2.micro"

  tags {
    Name = "k8m"
  }

  vpc_security_group_ids = ["${aws_security_group.k8m.id}"]
  key_name = "iia"

}

output "public_ip" {
  value = "${aws_instance.k8m.public_ip}"
}
