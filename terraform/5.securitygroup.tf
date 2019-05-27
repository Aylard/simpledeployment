resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Default SG for WEB instances"
  vpc_id      = "${aws_vpc.main.id}"
}

resource "aws_security_group_rule" "allow_all" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.web_sg.id}"

  depends_on = ["aws_security_group.web_sg"]
}

resource "aws_security_group_rule" "allow_ssh" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.web_sg.id}"

  depends_on = ["aws_security_group.web_sg"]
}

resource "aws_security_group_rule" "outbound_all" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = -1
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.web_sg.id}"

  depends_on = ["aws_security_group.web_sg"]
}
