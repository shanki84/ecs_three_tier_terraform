data "terraform_remote_state" "s3_bucket" {
  backend = "s3"

  config = {
    bucket  = var.state_s3_bucket
    key     = var.s3_bucket_path
    region  = "eu-west-2"
  }
}
