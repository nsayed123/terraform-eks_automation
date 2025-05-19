

# route53.tf
data "aws_route53_zone" "main" {
  name = var.zone_name
}

resource "aws_route53_record" "public" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.public_hostname # e.g. superset.example.com
  type    = "CNAME"
  ttl     = 300
  records = var.alb_dns_records # Replace with actual ALB output
}

# resource "aws_route53_record" "private" {
#   zone_id = data.aws_route53_zone.main.zone_id
#   name    = var.private_hostname
#   type    = "A"
#   ttl     = 300
#   records = [var.private_ip]
# }
