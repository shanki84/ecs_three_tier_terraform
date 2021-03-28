locals {
  ecs-node-userdata = <<EOF
#!/bin/bash
yum install -y nginx
echo "<h1>Welcome to nginx!</h1>" > /usr/share/nginx/html/index.html
service nginx start
EOF
}

resource "aws_instance" "web1" {
    ami                     = "${var.image-id}"
    instance_type           = "${var.instance-type}"
    subnet_id               = "${aws_subnet.private.*.id}"
    vpc_security_group_ids  = ["${aws_security_group.ecs-node.id}"]
    key_name                = "${var.env}-ecs-key"
    user_data_base64        = "${base64encode(locals.ecs-node-userdata)}"
    lifecycle {
      create_before_destroy = true
    }
}
