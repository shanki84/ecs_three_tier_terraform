locals {
  ecs-node-userdata = <<EOF
#!/bin/bash
yum install -y nginx
echo "<h1>Hello from August! :)</h1>" > /usr/share/nginx/html/index.html
service nginx start
EOF
}

resource "aws_launch_configuration" "ecsnode" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-node.name}"
  image_id                    = "${var.image-id}"
  instance_type               = "${var.instance-type}"
  key_name                    = "${var.env}-ecs-key"
  name_prefix                 = "${var.env}-ecs"
  security_groups             = ["${aws_security_group.ecs-node.id}"]
  user_data_base64            = "${base64encode(locals.ecs-node-userdata)}"

  lifecycle {
    create_before_destroy = true
  }
}
