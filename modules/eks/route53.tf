variable "route53_zone_id" {
  type = string
}

variable "app_hostname" {
  type    = string
  default = "app.al-shak.online"
}

# 1) קוראים את ה-DNS של ה-NLB מתוך ה-Service של ingress-nginx
data "kubernetes_service_v1" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }

  depends_on = [helm_release.ingress_nginx]
}

locals {
  nlb_dns_name = data.kubernetes_service_v1.ingress_nginx.status[0].load_balancer[0].ingress[0].hostname
}

# 2) canonical zone id של NLB לפי region (לא צריך לחפש את ה-LB עצמו)
data "aws_region" "current" {}

data "aws_lb_hosted_zone_id" "nlb" {
  region = data.aws_region.current.name
  # אם אצלך זה דורש גם type, תגיד לי ונוסיף:
  # load_balancer_type = "network"
}

resource "aws_route53_record" "app" {
  zone_id = var.route53_zone_id
  name    = var.app_hostname
  type    = "A"

  alias {
    name                   = "dualstack.${local.nlb_dns_name}"
    zone_id                = data.aws_lb_hosted_zone_id.nlb.id
    evaluate_target_health = true
  }
}
