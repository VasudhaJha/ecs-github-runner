/*
Internet
   |
[Internet Gateway] <-- Public Route Table
   |
[Public Subnets] -- (Load Balancer lives here)
   |
[NAT Gateway + EIP] <-- Private Route Table
   |
[Private Subnets] -- (ASG instances with GitHub runners)
*/

# 1. Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = merge(var.common_tags, {
    "Name" = "github-runner-vpc"
  })
}

# 2. Dynamically fetch available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# 3. Create public subnets across AZs
resource "aws_subnet" "public" {
  for_each = toset(data.aws_availability_zones.available.names)

  vpc_id = aws_vpc.main.id
  # cidrsubnet(base_cidr, new_bits, index) works like this:
  # base_cidr = "10.0.0.0/16"
  # new_bits = 4, so /16 + 4 = /20 blocks.
  # index = n, the offset inside the block.
  # Each index = "give me the nth /20 block inside this /16 space".
  cidr_block = cidrsubnet(var.vpc_cidr_block, 4, index(data.aws_availability_zones.available.names, each.key))
  availability_zone = each.key

  tags = merge(var.common_tags, {
    "Name" = "public-subnet-${each.key}",
    "Type" = "public"
  })
}

# 4. Create private subnets across AZs
resource "aws_subnet" "private" {
  for_each = toset(data.aws_availability_zones.available.names)

  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr_block, 4, index(data.aws_availability_zones.available.names, each.key) + var.private_subnet_offset)
  availability_zone = each.key

  tags = merge(var.common_tags, {
    "Name" = "private-subnet-${each.key}",
    "Type" = "private"
  })
}

# 5. Create an internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    "Name" = "github-runner-igw"
  })
}

# 6. Create public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.common_tags, {
    "Name" = "public-route-table"
  })
}

# 7. Associate public route table with public subnets
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public
  subnet_id = each.value.id
  route_table_id = aws_route_table.public.id
  
}

# 8. Create eip for NAT gateway
resource "aws_eip" "nat_eip" {
  domain           = "vpc"
}

# 9. Create NAT gateway in public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public[keys(aws_subnet.public)[0]].id

  tags = merge(var.common_tags, {
    "Name" = "nat-gateway"
  })

  depends_on = [aws_internet_gateway.igw]
}

# 10. Create private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(var.common_tags, {
    "Name" = "private-route-table"
  })
}

# 11. Associate private route with private subnets
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id = each.value.id
  route_table_id = aws_route_table.private.id
}







