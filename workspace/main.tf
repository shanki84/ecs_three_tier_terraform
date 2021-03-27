module "my_ecs" {
  source                = "../modules/eks"
  env                   = "${var.env[terraform.workspace]}"
  cidr-vpc              = "${var.cidr-vpc[terraform.workspace]}"
  cidr-subnet           = "${var.cidr-subnet[terraform.workspace]}"
  image-id              = "${var.image-id}"
  number_of_instances   = "${var.number_of_instances}"
  instance-type         = "${var.instance-type}"
  desired-capacity      = "${var.desired-capacity}"
  max_size              = "${var.max_size}"
  min_size              = "${var.min_size }"
  aws_region            = "${var.aws_region}"
  state_s3_bucket       = "${state_s3_bucket[terraform.workspace]}"
  bucket_path           = "${bucket_path[terraform.workspace]}"
}

module "route53" {
  source      = "../modules/nlb"
  zone_id     = data.aws_route53_zone.hostzone_id
  lb_arm_dns  = module.nlb.aws_lb_dns
  record_name = "${var.default_tags["env"]}-NLB"
  env         = "${var.env[terraform.workspace]}"
  vpc_id      = aws_vpc.ecs.id
}

module "rds" {
  allocated_storage  = "${var.allocated_storage}"
  engine_version     = "${var.engine_version}"
  instance_type      = "${var.instance_type}"
  subnet_ids         = ["${aws_subnet.rds.*.id}"]
  vpc_id             = "${aws_vpc.rds_db.id}"
}
