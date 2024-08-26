variable "base_vpc" {
    type = object({
      Name = string
      cidr = string
    })
      default = {
        Name = "VPC-A"
        cidr = "10.0.0.0/16"
      }
  
}


variable "base_igw" {
    type = object({
      Name = string
    })
      default = {
        Name = "VPC-A-IGW"
      }
  
}


//list of objects
//list, set -> default =[]
//map -> default = {"key" = {}, "key" = {}, "key" = {}}

variable "public_subnet_name" {
    type = map(object({
      cidr_block = string
      availability_zone= string
      Name = string
    }))
      default = {
        "Public-Subnet-1" = {
        cidr_block = "10.0.1.0/24"
        availability_zone = "ap-southeast-1a"
        Name = "My-Public-Subnet-1"
      },
      "Public-Subnet-2" = {
        cidr_block = "10.0.2.0/24"
        availability_zone = "ap-southeast-1b"
        Name = "My-Public-Subnet-2"
      },
      "Public-Subnet-3" ={
        cidr_block = "10.0.3.0/24"
        availability_zone = "ap-southeast-1c"
        Name = "My-Public-Subnet-3"
      }}
  
}

variable "public_RT" {
  default = "My_public_RT"
  
}

variable "Operation_System" {
    description = "Choose your OS: [ \"ubuntu\" , \"amazon-linux-2\" ]"
    type = string
    validation {
      condition = var.Operation_System == "ubuntu" || var.Operation_System == "amazon-linux-2"
      error_message = "This is false"

    }


}

variable "private_subnet_name" {
    type = map(object({
      cidr_block = string
      availability_zone= string
      Name = string
    }))
      default = {
        "Private-Subnet-1" = {
        cidr_block = "10.0.4.0/24"
        availability_zone = "ap-southeast-1a"
        Name = "My-Private-Subnet-1"
      },
      "Private-Subnet-2" = {
        cidr_block = "10.0.5.0/24"
        availability_zone = "ap-southeast-1b"
        Name = "My-Private-Subnet-2"
      },
      "Private-Subnet-3" ={
        cidr_block = "10.0.6.0/24"
        availability_zone = "ap-southeast-1c"
        Name = "My-Private-Subnet-3"
      }}
  
}


