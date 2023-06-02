provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "MyVPC"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
}

# EKS Configuration
resource "aws_eks_cluster" "my_cluster" {
  name     = "my-eks-cluster"
  role_arn = "arn:aws:iam::728037950362:role/my_terraform_test_role"
  version  = "1.22"

  vpc_config {
    subnet_ids = [
      aws_subnet.subnet1.id,
      aws_subnet.subnet2.id,
    ]
  }
}

# EKS Node Group Configuration
resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_eks_cluster.my_cluster.role_arn
  subnet_ids      = [
    aws_subnet.subnet1.id,
    aws_subnet.subnet2.id,
  ]
  
  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 2
  }
  
  instance_types = ["t1.micro"]
}
