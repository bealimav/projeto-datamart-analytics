variable "aws_region" {
  default = "us-east-1"
}

variable "ambiente" {
  default = "dev"
}

variable "projeto" {
  default = "datamart-qualidade"
}

variable "email_alerta" {
  description = "E-mail para receber notificações de falhas e custos"
  type        = string
}