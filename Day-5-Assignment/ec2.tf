# ssh keypair($ ssh keygen) "tls" provider
# private key (store in local)
# public key(used it to create EC2 keypair)
# Create EC2
# Allocate Elastic IP
# Binding EC2 with Elastic IP
# Security Group
# rules

# RSA key of size 4096 bits
resource "tls_private_key" "ssh_keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tls_private_key" {
    filename = "${path.root}/private_key.pem"
    content = tls_private_key.ssh_keypair.private_key_pem
  
}

resource "aws_key_pair" "ec2_key_pair" {
    key_name = "hmk.pub"
    public_key = tls_private_key.ssh_keypair.public_key_openssh

  
}

resource "aws_security_group" "server_sg" {
    vpc_id = aws_vpc.base_vpc.id
    name = "server-sg"
    tags = {
        Name = "Server_SG"
    }
  
}

resource "aws_vpc_security_group_ingress_rule" "ingress_ssh_allow" {
  security_group_id = aws_security_group.server_sg.id
  cidr_ipv4         = local.any_where
  from_port         = local.ssh
  ip_protocol       = "tcp"
  to_port           = local.ssh
}

resource "aws_vpc_security_group_egress_rule" "egress_all_allow" {
  security_group_id = aws_security_group.server_sg.id
  cidr_ipv4         = local.any_where
  ip_protocol       = local.any_protocol # semantically equivalent to all ports
}

resource "aws_instance" "server" {
    ami = local.selected_ami
    subnet_id = aws_subnet.base_subnets["Public-Subnet-1"].id
    instance_type = "t2.micro"
    vpc_security_group_ids = [ aws_security_group.server_sg.id ] 
    key_name = aws_key_pair.ec2_key_pair.key_name

    tags = {
        Name = "${local.vpc_name}-Server-1"
    }
  
}

resource "aws_eip" "public_eip" {
  domain = "vpc"
}

resource "aws_eip_association" "binding_server_eip" {
  instance_id = aws_instance.server.id
  allocation_id = aws_eip.public_eip.id
  
}






locals {
    
    ssh = 22
    any_where = "0.0.0.0/0"
    any_protocol = "-1"
  os_to_ami = {
    "ubuntu" = "ami-01811d4912b4ccb26"
    "amazon-linux-2" = "ami-0d07675d294f17973"

  }
  ssh_username = {
    "ami-01811d4912b4ccb26" = "ubuntu"
    "ami-0d07675d294f17973" = "ec2-user"
  }

  selected_ami = lookup(local.os_to_ami,var.Operation_System, "whoami")
}
