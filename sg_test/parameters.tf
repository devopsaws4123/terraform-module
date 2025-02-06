resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.enviornment}/vpc"
  type  = "String"
  value = var.vpc_id
}