provider "aws" {
    region = "ap-south-1"
    access_key = "AKIAYS2NV4PXH35ZC4YT"
    secret_key = "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"

}


variable "aws_subnet_cidr_block"{
   description = "subnet cidr block"
}

variable "vpc_cidr_block"{
   description = "subnet cidr block"
}

variable "environment"
    description = "deployment environment"

resource "aws_vpc" "terraform_test"{
    cidr_block = var.vpc_cidr_block
    tags = {
       Name = "terra-test"
       vpc_env = "dev"   }
}


resource "aws_subnet" "dev_subnet-1"{
    vpc_id = aws_vpc.terraform_test.id
    cidr_block = var.aws_subnet_cidr_block
    availability_zone = "ap-south-1a"
    tags = {
       Name = "var.environment" }

}

data "aws_vpc" "existing_vpc" {
   default = true
}

resource "aws_subnet" "subnet-2"{
   vpc_id = data.aws_vpc.existing_vpc.id
   cidr_block = "172.31.48.0/24"
   availability_zone =  "ap-south-1b"
   tags = {
      Name = "t-subnet1-dev" }
}

output "vpc-id"{
   value = aws_vpc.terraform_test.id
}
output "aws_subnet"{
value = aws_subnet.dev_subnet-1.id
}

