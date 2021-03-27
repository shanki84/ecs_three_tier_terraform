#  * EC2 Security Group to allow networking traffic

resource "aws_security_group" "ecs_sg" {
  name   = "${var.default_tags["env"]}-ECS-INSTANCE-SG"
  vpc_id = "${aws_vpc.ecs.id}"
  description = "ECS Cluster SG"
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["env"]}-ECS-SG",
      "Role", "SG",
    )
  )
}

resource "aws_security_group_rule" "ecs_web_port" {
  security_group_id = "aws_security_group.ecs_sg.id"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "http"
  description       = "web"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "out_http_app" {
  security_group_id = "aws_security_group.ecs_sg.id"
  type              = "egress"
  description       = "web"
  from_port         = 80
  to_port           = 80
  protocol          = "http"
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "ecs_node" {
  description         = "Allow node to communicate with each other"
  security_group_id   = "aws_security_group.ecs_sg.id"
  type                = "ingress"
  from_port           = 0
  to_port             = 65535
  protocol            = "tcp"
  cidr_blocks         = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ecs-cluster-ingress-workstation-https" {
  cidr_blocks       = ["${local.workstation-external-cidr}"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.ecs-cluster.id}"
  to_port           = 443
  type              = "ingress"
}
