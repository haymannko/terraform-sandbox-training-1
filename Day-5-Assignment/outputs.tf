output "my_zones" {
    value = data.aws_availability_zones.available.names
  
}

output "vpc_name" {
    value = "My VPC name is ${aws_vpc.base_vpc.tags.Name}"
  
}

output "igw_name" {
    value = "My IGW name is ${aws_internet_gateway.base_igw.tags.Name}"
  
}

output "ssh_command" {
    value = "ssh -i ${local_file.tls_private_key.filename} ${lookup(local.ssh_username,local.selected_ami,"No Needed")}@${aws_eip.public_eip.public_ip}"
  
}

