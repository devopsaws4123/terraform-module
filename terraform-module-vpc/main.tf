# VPC setup
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

   tags = {
    Name = "${var.project}-${var.enviornment}"
  }
}

# internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.enviornment}-${var.internet_gateway}"
  }
}

# public subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-${var.enviornment}-public-${local.az_names[count.index]}"
  }
}

# private subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  

  tags = {
    Name = "${var.project}-${var.enviornment}-private-${local.az_names[count.index]}"
  }
}

# database subnets
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  

  tags = {
    Name = "${var.project}-${var.enviornment}-database-${local.az_names[count.index]}"
  }
}

# elastic ip
resource "aws_eip" "nat" {
  domain   = "vpc"
}

# natgateway
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

tags = {
    Name = "${var.project}-${var.enviornment}-nat"
  }



  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

# public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

 tags = {
    Name = "${var.project}-${var.enviornment}-public"
  }
 
}

# private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

 tags = {
    Name = "${var.project}-${var.enviornment}-private"
  }
 
}

# database route table
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

 tags = {
    Name = "${var.project}-${var.enviornment}-database"
  }
 
}

# public route
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

# private route
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.example.id
}

# database route
resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.example.id
}


# public subents association
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# private subents association
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# database subents association
resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}
