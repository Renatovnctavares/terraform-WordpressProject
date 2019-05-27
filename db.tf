resource "aws_db_instance" "wordpress_db" {
  allocated_storage   = "${var.webapp_db_size}"
  engine              = "${var.webapp_db_engine}"
  engine_version      = "${var.webapp_db_engine_version}"
  instance_class      = "${var.webapp_db_instance_class}"
  storage_type        = "gp2"
  name                = "${var.webapp_db_name}"
  username            = "${var.webapp_db_user}"
  password            = "${var.webapp_db_password}"
  publicly_accessible    = false
  db_subnet_group_name   = "${aws_db_subnet_group.db_subnetgroup.id}"
  port                   = 3306
  vpc_security_group_ids = ["${aws_security_group.sg_dokerserver_db.id}"]
  availability_zone      = "${data.aws_availability_zones.available.names[0]}"
  skip_final_snapshot    = true
}


resource "aws_security_group" "sg_dokerserver_db" {
  name        = "SG_WordpressDb"
  vpc_id      = "${aws_vpc.vpc_hml.id}"
   


ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.vpc_hml.cidr_block}"]
  }



  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "db_subnetgroup" {
  name       = "db-subnetgp"
  subnet_ids = ["${aws_subnet.subnet_hmla.id}", "${aws_subnet.subnet_hmlb.id}"]

  tags = {
    Name = "My DB subnet group"
  }
}



