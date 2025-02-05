variable "cidr_block" {
  
}

variable "project" {

}

variable "enviornment" {
  
}

variable "internet_gateway" {
  
}

variable "public_subnet_cidrs" {
  
  type = list
    validation {
        condition     = length(var.public_subnet_cidrs) == 2
        error_message = "Please provide 2 valid public subnet CIDR"
    }
}

variable "private_subnet_cidrs" {
  
  type = list
    validation {
        condition     = length(var.private_subnet_cidrs) == 2
        error_message = "Please provide 2 valid private subnet CIDR"
    }
}

variable "database_subnet_cidrs" {
  
  type = list
    validation {
        condition     = length(var.database_subnet_cidrs) == 2
        error_message = "Please provide 2 valid database subnet CIDR"
    }
}

