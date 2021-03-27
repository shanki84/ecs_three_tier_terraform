#  * AutoScaling Launch Configuration to configure worker instances
#  * AutoScaling Group to launch worker instances

resource "aws_autoscaling_group" "ecs" {
  count                = "${var.number_of_instances}"
  desired_capacity     = "${var.desired-capacity}"
  launch_configuration = "${aws_launch_configuration.demo.id}"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  name                 = "${var.env}-ECS-NODE"
  vpc_zone_identifier  = ["${aws_subnet.private.*.id}"]

  tag {
    key                 = "Name"
    value               = "${var.env}-ECS-NODE-${count.index}"
    propagate_at_launch = true
  }
}
