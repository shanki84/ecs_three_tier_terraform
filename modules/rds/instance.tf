locals {
  resource_name_prefix = "${var.namespace}-${var.resource_tag_name}"
}

resource "aws_db_subnet_group" "rds" {
  name       = "${local.resource_name_prefix}-${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "rds" {
  identifier                = "${var.rds_instance_identifier}"
  allocated_storage         = "${var.allocated_storage}"
  backup_retention_period   = var.backup_retention_period
  backup_window             = var.backup_window
  maintenance_window        = var.maintenance_window
  engine                    = "mysql"
  engine_version            = "${var.engine_version}"
  instance_class            = "${var.instance_type}"
  multi_az                  = var.multi_az
  name                      = "${var.database_name}"
  username                  = "${var.database_user}"
  password                  = "${var.database_password}"
  port                      = var.port
  publicly_accessible       = var.publicly_accessible
  storage_encrypted         = var.storage_encrypted
  storage_type              = var.storage_type
  db_subnet_group_name      = "${aws_db_subnet_group.rds.id}"
  vpc_security_group_ids    = ["${aws_security_group.rds.id}"]
  snapshot_identifier       = var.snapshot_identifier
  skip_final_snapshot       = true
  final_snapshot_identifier = var.final_snapshot_identifier
  performance_insights_enabled = var.performance_insights_enabled
}

resource "random_string" "password" {
  length  = 16
  special = false
}
