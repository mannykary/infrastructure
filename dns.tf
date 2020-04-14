data "aws_route53_zone" "route53_zone_domain" {
  name = var.domain
}

resource "aws_acm_certificate" "acm_certificate" {
  domain_name               = data.aws_route53_zone.route53_zone_domain.name
  subject_alternative_names = ["*.${var.domain}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "domain_cert_validation" {
  name    = aws_acm_certificate.acm_certificate.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.acm_certificate.domain_validation_options.0.resource_record_type
  zone_id = data.aws_route53_zone.route53_zone_domain.zone_id
  records = [aws_acm_certificate.acm_certificate.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "domain_acm_cert_validation" {
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [aws_route53_record.domain_cert_validation.fqdn]

  depends_on = [
    aws_route53_record.domain_cert_validation
  ]
}

resource "aws_route53_record" "main" {
  name = "*.${var.domain}"
  type = "CNAME"
  zone_id = data.aws_route53_zone.route53_zone_domain.id
  records = [aws_alb.alb_ext.dns_name]
  ttl = 120
}
