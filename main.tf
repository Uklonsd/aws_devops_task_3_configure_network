# 1. Create a subnet
resource "aws_subnet" "subnet" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "grafana"
  }
}
# 2. Create an Internet Gateway and attach it to the vpc
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}
# 3. Configure routing for the Internet Gateway
resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}
# 4. Create a Security Group and inbound rules

resource "aws_security_group" "sg" {
  name   = "mate-aws-grafana-lab"
  vpc_id = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 3000
  ip_protocol = "tcp"
  to_port     = 3000
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg.id

  cidr_ipv4   = "176.38.64.204/32"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}
# 5. Uncommend (and update the value of security_group_id if required) outbound rule - it required
# to allow outbound traffic from your virtual machine: 
resource "aws_vpc_security_group_egress_rule" "allow_all_eggress" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}
