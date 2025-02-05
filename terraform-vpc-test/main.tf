module "vpc" {
    source = "../terraform-module-vpc"
    cidr_block = var.vpc_cidr
    project = var.project
    enviornment = var.enviornment
    internet_gateway = var.internet_gateway
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    database_subnet_cidrs = var.database_subnet_cidrs
    
}