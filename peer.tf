
data "aws_vpc" "vpc_main" {
   default = true

}



data "aws_caller_identity" "peer" {
  provider = "aws.peer"
}



provider "aws" {
  alias  = "peer"
  region = "${var.region}"

  # Accepter's credentials.
}

# Requester's side of the connection.
resource "aws_vpc_peering_connection" "peer" {
  vpc_id        = "${data.aws_vpc.vpc_main.id}"
  peer_vpc_id   = "${aws_vpc.vpc_hml.id}"
  peer_owner_id = "${data.aws_caller_identity.peer.account_id}"
  peer_region   = "${var.region}"
  auto_accept   = false

  tags = {
    Side = "Requester"
  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = "aws.peer"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer.id}"
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

#route back

resource "aws_route" "peer_add_back"{
  route_table_id            = "${data.aws_route_table.selected.id}"
  destination_cidr_block    = "${data.aws_vpc.vpc_main.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer.id}"

}


#route go
#find out data about main vpc
data "aws_route_table" "default_vpc" {
  vpc_id = "${data.aws_vpc.vpc_main.id}"
}



resource "aws_route" "peer_add_forw"{
  route_table_id            = "${data.aws_route_table.default_vpc.id}"
  destination_cidr_block    = "${aws_subnet.subnet_hmla.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer.id}"

}



