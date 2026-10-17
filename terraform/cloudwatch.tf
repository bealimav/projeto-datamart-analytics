# ============================================================
# CLOUDWATCH - ALARMES DE ERRO E LENTIDÃO
# ============================================================

# Alarme de Erro na Lambda
resource "aws_cloudwatch_metric_alarm" "lambda_erros" {
  alarm_name          = "${var.projeto}-lambda-erros-${var.ambiente}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "300" # 5 minutos
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Alerta quando a Lambda de validacao falhar"
  alarm_actions       = [aws_sns_topic.alertas.arn]

  dimensions = {
    FunctionName = aws_lambda_function.valida_ingestao.function_name
  }
}

# Alarme de Duração Alta (Lambda lenta)
resource "aws_cloudwatch_metric_alarm" "lambda_duracao" {
  alarm_name          = "${var.projeto}-lambda-lenta-${var.ambiente}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Average"
  threshold           = "5000" # 5 segundos
  alarm_description   = "Alerta quando a Lambda demorar mais de 5s"
  alarm_actions       = [aws_sns_topic.alertas.arn]

  dimensions = {
    FunctionName = aws_lambda_function.valida_ingestao.function_name
  }
}