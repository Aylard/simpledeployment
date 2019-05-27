resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"
  instance_tenancy = "dedicated"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  depends_on = ["aws_vpc.main"]
}

resource "aws_subnet" "dev" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = true

  depends_on = ["aws_internet_gateway.gw"]
}
