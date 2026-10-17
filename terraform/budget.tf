# ============================================================
# FINOPS - AWS BUDGETS (CONTROLE DE CUSTO)
# ============================================================

resource "aws_budgets_budget" "limite_custo" {
  name              = "${var.projeto}-budget-${var.ambiente}"
  budget_type       = "COST"
  limit_amount      = "1.0" # Avisa se passar de 1 dólar
  limit_unit        = "USD"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80 # Avisa em 80% de 1 dólar (0.80)
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.email_alerta]
  }
}