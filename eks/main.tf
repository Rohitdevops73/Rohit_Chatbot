# Provider
provider "aws"{
    region = "ap-south-1"
}
# vpc creation
resource "aws_vpc" "rohitchatbot_vpc"{
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "rohitchatbot_vpc"
    }
 }

 # creating subnet

resource "aws_subnet" "rohitchatbot_subnet" {
    count = 2
    vpc_id = aws_vpc.rohitchatbot_vpc.id
    cidr_block = cidrsubnet(aws_vpc.rohitchatbot_vpc.cidr_block,8, count.index)
    availability_zone = element(["ap-south-1a", "ap-south-1b"],count.index)
    map_public_ip_on_launch = true 

    tags = {
        Name = "rohitchatbot_subnet-${count.index}"

    }
 }
  # internet gateway creation
    resource "aws_internet_gateway" "rohitchatbot_igw" {
        vpc_id = aws_vpc.rohitchatbot_vpc.id

        tags = {
            Name = "rohitchatbot_igw"
        }
    }
    # route table creation
    resource "aws_route_table" "rohitchatbot_route_table" {
        vpc_id = aws_vpc.rohitchatbot_vpc.id
        route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.rohitchatbot_igw.id
        }
        tags = {
            Name = "rohitchatbot_route_table"
        }
    }
    # route table association
    resource "aws_route_table_association" "rohitchatbot_route_table_association" {
        count = 2
        subnet_id = aws_subnet.rohitchatbot_subnet[count.index].id
        route_table_id = aws_route_table.rohitchatbot_route_table.id
    }
    # security group creation
    resource "aws_security_group" "rohitchatbot_cluster_sg" {
        vpc_id = aws_vpc.rohitchatbot_vpc.id
             
    
        egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }
        tags ={
            Name = "rohitchatbot-cluster-sg"
        }
        
    }
    resource "aws_security_group" "rohitchatbot_node_sg" {
        vpc_id = aws_vpc.rohitchatbot_vpc.id
    
        egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }
        tags ={
            Name = "rohitchatbot-node-sg"
        }
        ingress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    #create EKS cluster
    resource "aws_eks_cluster" "rohitchatbot_eks_cluster" {
        name = "rohitchatbot-eks-cluster"
        role_arn = aws_iam_role.rohitchatbot_cluster_role.arn
        vpc_config {
            subnet_ids = aws_subnet.rohitchatbot_subnet[*].id
            security_group_ids = [aws_security_group.rohitchatbot_cluster_sg.id]
        }
        depends_on = [
            aws_iam_role_policy_attachment.rohitchatbot_cluster_role_policy
        ]
    }
    #create EKS node group
    resource "aws_eks_node_group" "rohitchatbot_eks_node_group" {
        cluster_name = aws_eks_cluster.rohitchatbot_eks_cluster.name  
        node_group_name = "rohitchatbot-eks-node-group"  
        node_role_arn = aws_iam_role.rohitchatbot_node_group_role.arn
        subnet_ids = aws_subnet.rohitchatbot_subnet[*].id
        
        scaling_config {
            desired_size = 2
            max_size = 3
            min_size = 1
        }
        instance_types = ["c7i-flex.large"]
        
        remote_access {
            ec2_ssh_key = var.ssh_key_name
            source_security_group_ids = [aws_security_group.rohitchatbot_node_sg.id]
        }
    depends_on = [
        aws_iam_role_policy_attachment.rohitchatbot_node_role_policy,
        aws_iam_role_policy_attachment.rohitchatbot_cni_policy,
        aws_iam_role_policy_attachment.rohitchatbot_ec2_container_registry_policy
    ]
    }
    # IAM role creation

    resource "aws_iam_role" "rohitchatbot_cluster_role" {
        name = "rohitchatbot_cluster_role"
        assume_role_policy = <<EOF
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": "sts:AssumeRole",
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "eks.amazonaws.com"
                    }
                }
            ]
        }
        EOF
    }

    resource "aws_iam_role_policy_attachment" "rohitchatbot_cluster_role_policy" {
        role = aws_iam_role.rohitchatbot_cluster_role.name
        policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
        
    }
    # IAM role creation

    resource "aws_iam_role" "rohitchatbot_node_group_role" {
        name = "rohitchatbot_node_group_role"
        assume_role_policy = <<EOF
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": "sts:AssumeRole",
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "ec2.amazonaws.com"
                    }
                }
            ]
        }
        EOF 
        
    }

      resource "aws_iam_role_policy_attachment" "rohitchatbot_node_role_policy" {
        role = aws_iam_role.rohitchatbot_node_group_role.name
        policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        
    }
      resource "aws_iam_role_policy_attachment" "rohitchatbot_cni_policy" {
            role = aws_iam_role.rohitchatbot_node_group_role.name
            policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
            
    }
      resource "aws_iam_role_policy_attachment" "rohitchatbot_ec2_container_registry_policy" {
            role = aws_iam_role.rohitchatbot_node_group_role.name
            policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
            
    }

   

    