# ============================================================
# SNS - NOTIFICAÇÕES (ALARMES)
# ============================================================

resource "aws_sns_topic" "alertas" {
  name = "${var.projeto}-alertas-${var.ambiente}"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alertas.arn
  protocol  = "email"
  endpoint  = var.email_alerta
}