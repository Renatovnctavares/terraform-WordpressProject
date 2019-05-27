resource "aws_elb" "elb_wordpress" {
  name               = "Wordpress-elb"
  subnets            = ["${aws_subnet.subnet_hmla.id}","${aws_subnet.subnet_hmlb.id}"]
  security_groups    = ["${aws_security_group.sg_wordpresslb.id}"]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 30
  }

  instances                   = ["${aws_instance.ec2docker.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "LB-Wordpress"
  }
}


resource "aws_security_group" "sg_wordpresslb" {
  name        = "SG_WordpressLB"
  vpc_id      = "${aws_vpc.vpc_hml.id}"



ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}



