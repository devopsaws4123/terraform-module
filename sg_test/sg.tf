module "sg" {
    source = "../terraform-module-securitygroup"
    name = var.name
    description = var.description
    project_name = var.project_name
    enviornment = var.enviornment
    vpc_id = aws_ssm_parameter.vpc_id.value
    sg_name = var.sg_name
}