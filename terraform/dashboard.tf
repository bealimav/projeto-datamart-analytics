# ============================================================
# CLOUDWATCH - DASHBOARD VISUAL
# ============================================================

resource "aws_cloudwatch_dashboard" "pipeline_dashboard" {
  dashboard_name = "${var.projeto}-dashboard-${var.ambiente}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", aws_lambda_function.valida_ingestao.function_name],
            [".", "Errors", ".", "."],
            [".", "Duration", ".", ".", { "stat" : "Average" }]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "Métricas da Lambda - Ingestão"
        }
      }
    ]
  })
}