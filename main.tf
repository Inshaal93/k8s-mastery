provider "aws" { #where the vms are and how to get there
 region = "us-west-1"
 access_key = "AKIAJZA66LAIVUZN4G3A"
 secret_key = "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"
}

data "aws_availability_zones" "all" {} #a list of the availibility_zones this account has

resource "aws_security_group" "k8m" { #network security group for ec2 instance
  name = "k8m_sg"
  ingress { //everything
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress { //nginx
  #   from_port = "80"
  #   to_port = "80"
  #   protocol = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  #
  # ingress { //python
  #   from_port = "5000"
  #   to_port = "5000"
  #   protocol = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  #
  # ingress { //springboot
  #   from_port = "8080"
  #   to_port = "8080"
  #   protocol = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  #
  # ingress { //nodejs
  #   from_port = "3000"
  #   to_port = "3000"
  #   protocol = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  #
  # ingress { //ssh
  #   from_port = "22"
  #   to_port = "22"
  #   protocol = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

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

# resource "aws_autoscaling_group" "example" { #defines what the vm configs are and how to scale
#   launch_configuration = "${aws_launch_configuration.example.id}"
#   availability_zones = ["${data.aws_availability_zones.all.names}"] #using the data source to fetch names of all availibility_zones and passing here
#   min_size = 2
#   max_size = 10
#
#   load_balancers = ["${aws_elb.example.name}"] #use the load balancer defned below
#   health_check_type = "ELB" #Use the healthcheck defined in the ELB
#
#   tag {
#     key = "Name"
#     value = "terraform-asg-example"
#     propagate_at_launch = true
#   }
# }

# resource "aws_elb" "example" { #a load balancer to
#   name = "terraform-asg-example"
#   security_groups = ["${aws_security_group.elb.id}"]
#   availability_zones = ["${data.aws_availability_zones.all.names}"]
#
#   health_check {
#     healthy_threshold = 2
#     unhealthy_threshold = 2
#     timeout = 3
#     interval = 30
#     target = "HTTP:${var.server_port}/"
#   }
#
#   listener {
#     lb_port = 80 #take everything coming on 80 and route to the instances in ASG
#     lb_protocol = "http"
#     instance_port = "${var.server_port}"
#     instance_protocol = "http"
#   }
# # }
#
# resource "aws_security_group" "elb" { #network security group for the load balancer
#   name = "terraform-example-elb"
#
#   egress { #outbound rules
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   ingress { #inbound rules
#     from_port = 80
#     to_port = 80
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
#
# output "elb_dns_name" { #print the dns name of the load balancer
#   value = "${aws_elb.example.dns_name}"
# }


# used for sing server deployment
