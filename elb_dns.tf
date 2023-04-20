resource "aws_route53_record" "lb_dns" {
  count   = var.create_elb && var.create_dns ? 1 : 0
  zone_id = try(var.dns_zone_id, "")
  name    = "*"
  type    = "A"

  alias {
    name                   = concat(aws_lb.this.*.dns_name, [""])[0]
    zone_id                = concat(aws_lb.this.*.zone_id, [""])[0]
    evaluate_target_health = false
  }
  depends_on = [
    aws_lb.this
  ]
}
