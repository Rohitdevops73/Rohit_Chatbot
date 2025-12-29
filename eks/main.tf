# Provider
provider "aws"{
    region = "us-east-1"
}
# vpc creation
 resource "aws"vpc" "rohitchatbot_vpc"{
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "rohitchatbot_vpc"
    }
 }

 # creating subnet