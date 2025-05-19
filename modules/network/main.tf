resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-${var.azs[count.index]}"
  }
}

resource "aws_subnet" "private_eks" {
  count = length(var.private_subnet_cidrs_eks)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs_eks[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.vpc_name}-private-eks-${var.azs[count.index]}"
  }
}

resource "aws_subnet" "private_rds" {
  count = length(var.private_subnet_cidrs_rds)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs_rds[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.vpc_name}-private-rds-${var.azs[count.index]}"
  }
}



# resource "aws_vpc_ipv4_cidr_block_association" "secondary" {
#   vpc_id     = aws_vpc.this.id
#   cidr_block = var.secondary_cidr_block
# }

# resource "aws_subnet" "private_eks_secondary" {
#   count = length(var.secondary_private_subnet_cidrs_eks)

#   vpc_id            = aws_vpc.this.id
#   cidr_block        = var.secondary_private_subnet_cidrs_eks[count.index]
#   availability_zone = var.azs[count.index]

#   depends_on = [aws_vpc_ipv4_cidr_block_association.secondary]

#   tags = {
#     Name = "${var.vpc_name}-private-eks-secondary-${var.azs[count.index]}"
#   }
# }

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_eip" "nat" {
  count  = length(var.azs)
  domain = "vpc"

  tags = {
    Name = "${var.vpc_name}-nat-eip-${var.azs[count.index]}"
  }
}


resource "aws_nat_gateway" "this" {
  count         = length(var.azs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.vpc_name}-nat-${var.azs[count.index]}"
  }

  depends_on = [aws_internet_gateway.this]
}

####################################
resource "aws_route_table" "private_eks" {
  count  = length(var.private_subnet_cidrs_eks)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[count.index].id
  }

  tags = {
    Name = "${var.vpc_name}-private-rt-eks-${var.azs[count.index]}"
  }
}

resource "aws_route_table_association" "private_eks" {
  count          = length(var.private_subnet_cidrs_eks)
  subnet_id      = aws_subnet.private_eks[count.index].id
  route_table_id = aws_route_table.private_eks[count.index].id
}

##############################
resource "aws_route_table" "private_rds" {
  count  = length(var.private_subnet_cidrs_rds)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[count.index].id
  }

  tags = {
    Name = "${var.vpc_name}-private-rt-rds-${var.azs[count.index]}"
  }
}

resource "aws_route_table_association" "private_rds" {
  count          = length(var.private_subnet_cidrs_rds)
  subnet_id      = aws_subnet.private_rds[count.index].id
  route_table_id = aws_route_table.private_rds[count.index].id
}

# ####################################
# resource "aws_route_table" "private_sec_eks" {
#   count  = length(var.secondary_private_subnet_cidrs_eks)
#   vpc_id = aws_vpc.this.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.this[count.index].id
#   }

#   tags = {
#     Name = "${var.vpc_name}-private-rt-sec-eks-${var.azs[count.index]}"
#   }
# }

# resource "aws_route_table_association" "private_sec_eks" {
#   count          = length(var.secondary_private_subnet_cidrs_eks)
#   subnet_id      = aws_subnet.private_eks_secondary[count.index].id
#   route_table_id = aws_route_table.private_sec_eks[count.index].id
# }
#####################################


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
