data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "${var.public_ssh_key}"
}

resource "aws_instance" "web" {
  count         = "${var.web_instances_count}"
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids = ["${aws_security_group.web_sg.name}"]

  associate_public_ip_address = true
  subnet_id = "${aws_subnet.dev.id}"
  private_ip = "${lookup(var.web_instances_privateips,count.index)}"

  depends_on = ["aws_security_group.web_sg", "aws_subnet.dev", "aws_key_pair.deployer"]
}

output "private_ips" {
  value = ["${aws_instance.web.*.private_ip}"]
}

## Since VPN wasn't in requirements let's use simple EIP to connect later to VM via ansible
resource "aws_eip" "web" {
  count = "${var.web_instances_count}"
  vpc = true

  instance                  = "${element(aws_instance.web.*.id, count.index)}"
  associate_with_private_ip = "${lookup(var.web_instances_privateips,count.index)}"
  depends_on                = ["aws_internet_gateway.gw"]
}

output "public_ips" {
  value = ["${aws_instance.web.*.public_ip}"]
}
