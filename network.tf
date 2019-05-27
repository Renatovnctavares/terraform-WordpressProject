## VPC
resource "aws_vpc" "vpc_hml" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "VPC-HML"
  }
}

## Network

data "aws_availability_zones" "available" {}

resource "aws_subnet" "subnet_hmla" {
  vpc_id            = "${aws_vpc.vpc_hml.id}"
  cidr_block        = "172.16.0.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "SUBNET-HML-a"
  }
  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_subnet" "subnet_hmlb" {
  vpc_id            = "${aws_vpc.vpc_hml.id}"
  cidr_block        = "172.16.1.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name = "SUBNET-HML-b"
  }
  depends_on = ["aws_internet_gateway.gw"]
}

## gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc_hml.id}"

  tags = {
    Name = "VPC_HML"
  }
}



## route


data "aws_route_table" "selected" {
  vpc_id = "${aws_vpc.vpc_hml.id}"
}


resource "aws_route" "gw_add"{
  route_table_id = "${data.aws_route_table.selected.id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.gw.id}"


}

