
## KEY

resource "tls_private_key" "gereted_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "mykey" {
  key_name   = "key-Dockerserver"
  public_key = "${tls_private_key.gereted_key.public_key_openssh}"
}



## Security group

resource "aws_security_group" "sg_dokerserver" {
  name        = "SG_DockerServer"
  vpc_id      = "${aws_vpc.vpc_hml.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 2376
    to_port     = 2376
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_vpc.vpc_main.cidr_block}"]
  }

 ingress {
    from_port   = 8080
    to_port     = 8080
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




## EC2

resource "aws_instance" "ec2docker" {
  ami           = "${var.amiawsid}"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.mykey.key_name}"
  associate_public_ip_address = true
  private_ip =  "172.16.0.100"
  subnet_id = "${aws_subnet.subnet_hmla.id}"
  vpc_security_group_ids  = ["${aws_security_group.sg_dokerserver.id}"]

  tags = {
    Name = "DockerServer"
  }


  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
   connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = "${aws_instance.ec2docker.private_ip}"
      private_key = "${tls_private_key.gereted_key.private_key_pem}"
    }

  }

   provisioner "file" {
    source      = "docker.service"
    destination = "/tmp/docker.service"

   connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = "${aws_instance.ec2docker.private_ip}"
      private_key = "${tls_private_key.gereted_key.private_key_pem}"
    }

}



  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh WORDPRESS_DB_USER=${var.webapp_db_user} WORDPRESS_DB_PASSWORD=${var.webapp_db_password} WORDPRESS_DB_HOST=${aws_db_instance.wordpress_db.endpoint} WORDPRESS_DB_NAME=${var.webapp_db_name}",
    ]

  connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = "${aws_instance.ec2docker.private_ip}"
      private_key = "${tls_private_key.gereted_key.private_key_pem}"
    }


  }
}


