// Module specific variables

variable "workspace" {
  description = "name of the workspace"
}

variable "env" {
  description = "name of the environment"
}

variable "cidr-vpc" {
  description = "The VPC the instance(s) will go in"
}

variable "cidr-private-subnet" {
  description = "The VPC private subnet the instance(s) will go in"
}

variable "cidr-private-subnet" {
  description = "The VPC public subnet the instance(s) will go in"
}

variable "aws_region" {
  description = "The region to use"
}

variable "state_s3_bucket" {
  description = "S3 bucket to store statefile"
}

variable "s3_bucket_path" {
  description = "S3 bucket path to store statefile"
}

variable "image-id" {
  description = "The AMI to use"
}

variable "number_of_instances" {
  description = "number of instances to be added"
}

variable "instance-type" {
  description = "type of instance"
}

variable "desired-capacity" {
  description = "number of instance required"
}

variable "max_size" {
  description = "max number of required instances"
}

variable "min_size" {
  description = "min number of required instances"
}
