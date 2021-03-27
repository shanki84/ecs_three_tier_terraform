data "aws_route53_zone" "hostzone_id"
  name         = "${var.env}.com."
  private_zone = true
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www.${data.aws_route53_zone.hostzone_id.name}"
  type    = "A"
  ttl     = "300"
  records = ["10.0.0.1"]
}
