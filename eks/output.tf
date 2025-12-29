output "cluster_id"{
    value = aws_eks_cluster.rohitchatbot_eks_cluster.id
}

output "node_group_id"{
    value = aws_eks_node_group.rohitchatbot_eks_node_group.id
}

output "vpc_id"{
    value = aws_vpc.rohitchatbot_vpc.id 
}   

output "subnet_ids"{
    value = aws_subnet.rohitchatbot_subnet[*].id
}