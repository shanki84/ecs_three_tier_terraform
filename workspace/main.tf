module "my_ecs" {
  source                = "../modules/ecs"
  env                   = "${var.env[terraform.workspace]}"
  cidr-vpc              = "${var.cidr-vpc}"
  cidr-private-subnet   = "${var.cidr-private-subnet[terraform.workspace]}"
  cidr-public-subnet    = "${var.cidr-public-subnet[terraform.workspace]}"
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

module "nlb" {
  source                = "../modules/nlb"
  load_balancer_type    = "network"
  internal              = false
  env                   = "${var.env[terraform.workspace]}"
  vpc_id                = aws_vpc.ecs.id
  subnets               = aws_security_group.ecs_sg.id
  security_groups       = modules.ecs.aws_security_group.ecs_sg.id
}

module "route53" {
  source      = "../modules/nlb"
  zone_id     = data.aws_route53_zone.hostzone_id
  record_name = "${var.default_tags["env"]}-NLB"
  env         = "${var.env[terraform.workspace]}"
  vpc_id      = aws_vpc.ecs.id
}

module "rds" {
  source              = "../modules/rds"
  resource_tag_name   = "${var.resource_tag_name}
  namespace           = "${var.namespace}
  region              = "${var.region}
  allocated_storage   = "${var.allocated_storage}"
  engine_version      = "${var.engine_version}"
  instance_type       = "${var.instance_type}"
  subnet_ids          = ["${aws_subnet.rds.*.id}"]
  vpc_id              = "${aws_vpc.rds_db.id}"
    route = [
      {
        cidr_block     = "0.0.0.0/0"
        gateway_id     = module.rds.vpc.gateway_id
        instance_id    = null
        nat_gateway_id = null
      }
    ]
}
