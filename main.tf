provider "aws" {
    region = "ap-south-1"
    access_key = "AKIAYS2NV4PXH35ZC4YT"
    secret_key = "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"

}

variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable availability_zone {}
variable env_prefix {}

resource "aws_vpc" "myapp-vpc"{
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "${var.env_prefix}-vpc"}
}


resource "aws_subnet" "myapp_subnet-1"{
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.availability_zone
    tags = {
       Name = "${var.env_prefix}-subnet-1" }

}

/*resource "aws_route_table" "myapp-rtb"{
    vpc_id = aws_vpc.myapp-vpc.id
     
    route {
       cidr_block = "0.0.0.0/0"
       gateway_id = aws_internet_gateway.myapp-igw.id 
    }
    tags = {
       Name = "${var.env_prefix}-rtb" 
    }
}*/

resource "aws_internet_gateway" "myapp-igw"{
   vpc_id = aws_vpc.myapp-vpc.id
   tags = {
      Name = "${var.env_prefix}-igw"
}
}

/*resource "aws_route_table_association" "a-rtb-subnet" {
    subnet_id = aws_subnet.myapp_subnet-1.id
    route_table_id = aws_route_table.myapp-rtb.id
}*/
  
resource "aws_default_route_table" "main-rtb" {
   default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.myapp-igw.id
     
}
}

resource "aws_security_group" "myapp-sg"{
    vpc_id =  aws_vpc.myapp-vpc.id
    name = "myapp-sg"

    ingress {
        from_port = "0"
        to_port = "0"
        protocol= "All"
        cidr_blocks = ["0.0.0.0/0"]
     }
     
     egress {
         from_port = "0"
         to_port = "0"
         protocol = "All"
         cidr_blocks = ["0.0.0.0/0"]
      }
}
