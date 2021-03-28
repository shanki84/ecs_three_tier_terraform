# VPC Resources
#  * VPC
#  * Subnets Public & Private
#  * Internet Gateway
#  * Route Table

resource "aws_vpc" "ecs" {
  cidr_block = "${var.cidr-vpc}"
  enable_dns_hostnames = true

  tags = "${
    map(
      "Name", "${var.env}-VPC",
    )
  }"
}

resource "aws_subnet" "private" {
  count = 3

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${cidr-private-subnet}.${count.index*64}/24"
  vpc_id            = "${aws_vpc.ecs.id}"
  map_public_ip_on_launch = "false" //it makes this a private subnet

  tags = "${
    map(
      "Name", "${var.env}-Private-Subnet-0${count.index+1}",
    )
  }"
}

resource "aws_subnet" "public" {
  count = 3

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${cidr-public-subnet}.${count.index*64}/24"
  vpc_id            = "${aws_vpc.ecs.id}"
  map_public_ip_on_launch = "true" //it makes this a public subnet

  tags = "${
    map(
      "Name", "${var.env}-Public-Subnet-0${count.index+1}",
    )
  }"
}
resource "aws_internet_gateway" "ecs" {
  vpc_id = "${aws_vpc.demo.id}"

  tags = {
    Name = "${var.env}-IGW"
  }
}

resource "aws_route_table" "ecs" {
  vpc_id = "${aws_vpc.ecs.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ecs.id}"
  }
}

resource "aws_route_table_association" "ecs" {
  count = 3

  subnet_id      = "${aws_subnet.private.*.id[count.index]}"
  route_table_id = "${aws_route_table.ecs.id}"

}
