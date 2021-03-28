variable "workspace" {
  type = "map"
  default = {
    nonprod     = "nonprod"
    prod        = "prod"
  }
}

variable "env" {
  type = map(any)
  default = {
    nonprod  = "nonprod"
    prod     = "prod"
  }
}

# ---- Network -------------- #
variable "cidr-vpc" {
  default = "10.0.0.0/16"
}
variable "cidr-private-subnet" {
  type = map(any)
  default = {
    nonprod = "10.43.22"
    prod    = "10.43.20"
  }
}
variable "cidr-public-subnet" {
  type = map(any)
  default = {
    nonprod = "10.43.23"
    prod    = "10.43.21"
  }
}

# ---- Auto Scalling Group ---- #
variable "image-id" {
  default = "ami-038d55c26bf01998f"
}
variable "aws_region" {
  default = "eu-west-2"
}
variable "number_of_instances" {
  description = "number of instances to make"
  default = 3
}
variable "instance-type" {
  default = "t2.medium"
}
variable "desired-capacity" {
  description = "How many desired nodes to create"
  default = 3
}
variable "max_size" {
  description = "How many max_size nodes to create"
  default = 7
}
variable "min_size" {
  description = "How many min_size nodes to create"
  default = 3
}

# ---- State File ---- #
variable "bucket_path" {
  type = map(any)
  default = {
    nonprod = "app/nonprod/terraform.state"
    prod    = "app/prod/terraform.state"
  }
}
variable "state_s3_bucket" {
  type = map(any)
  default = {
    nonprod    = "nonprod-state-bucket"
    prod       = "prod-state-bucket"
  }
}

local {
  default_tags = {
    env = var.env[terraform.workspace]
  }
}

#--- RDS ---#
variable "rds-cidr-vpc" {
  default = "10.0.0.0/16"
}
variable "allocated_storage" {
  default = 5
}
variable "engine_version" {
  default = 5.6.35
}
variable "instance_type" {
  default = "db.t2.micro"
}
