
data "aws_availability_zones" "available" {
    state = "available"
  
}

resource "aws_vpc" "base_vpc" {
    cidr_block = var.base_vpc.cidr //10.0.0.0/16
    tags = {
      Name = var.base_vpc.Name//VPC-A
    }
  
}


locals {
  vpc_name = aws_vpc.base_vpc.tags.Name
}

resource "aws_internet_gateway" "base_igw" {
    vpc_id = aws_vpc.base_vpc.id
    tags = {
      Name = var.base_igw.Name //VPC-A-IGW
    }
  
}

//each
resource "aws_subnet" "base_subnets" {
    for_each = var.public_subnet_name //map(object)=>3
    vpc_id = aws_vpc.base_vpc.id
    cidr_block =  each.value.cidr_block//10.0.1.0/24
    map_public_ip_on_launch = true
    availability_zone = each.value.availability_zone //ap-southeast-1a
    tags = {
      Name = "${local.vpc_name}-${each.value.Name}"
    }
 
}




resource "aws_route_table" "base_RT" {
  vpc_id = aws_vpc.base_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.base_igw.id
  }
  tags = {
    Name = var.public_RT
  }
  
}

resource "aws_route_table_association" "RT_ASSO" {
  for_each = aws_subnet.base_subnets
  route_table_id = aws_route_table.base_RT.id
  subnet_id =  each.value.id
  
}


resource "aws_nat_gateway" "NAT_GT" {
  allocation_id = aws_eip.NAT_eip.id
  subnet_id     = aws_subnet.base_subnets["Public-Subnet-2"].id

  tags = {
    Name = "my NAT GW"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.base_igw]
}


resource "aws_eip" "NAT_eip" {
  domain = "vpc"
  
}


resource "aws_subnet" "private_subnets" {
    for_each = var.private_subnet_name //map(object)=>3
    vpc_id = aws_vpc.base_vpc.id
    cidr_block =  each.value.cidr_block//10.0.4.0/24
    map_public_ip_on_launch = false
    availability_zone = each.value.availability_zone //ap-southeast-1a
    tags = {
      Name = "${local.vpc_name}-${each.value.Name}"
    }
 
}


resource "aws_route" "natGW_route" {
  route_table_id            = local.RT_id
  destination_cidr_block    = local.any_where
  nat_gateway_id = aws_nat_gateway.NAT_GT.id
 
}

locals {
  RT_id = "rtb-01df95b64577acb11"
}


