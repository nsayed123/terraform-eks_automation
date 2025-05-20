resource "aws_iam_policy" "eks_access" {
  name        = "eks-access-policy"
  description = "Allows access to describe and interact with EKS clusters"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:*"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:StartSession",
          "ssm:DescribeSessions",
          "ssm:GetSession",
          "ssm:TerminateSession"
        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role" "bastion_role" {
  name = "bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion-instance-profile"
  role = aws_iam_role.bastion_role.name
}


resource "aws_iam_role_policy_attachment" "bastion_ssm_access" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "bastion_eks_access" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = aws_iam_policy.eks_access.arn
}

resource "aws_security_group" "bastion_sg" {
  name        = "${var.vpc_id}-bastion-sg"
  description = "Allow SSH access to Bastion"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
  }
  user_data = file("${path.module}/userdata.sh")
  # user_data = <<-EOF
  #             #!/bin/bash
  #             set -e

  #             # Install dependencies
  #             sudo yum update -y
  #             sudo yum install -y unzip bash-completion vim  
  #             sudo yum install -y curl --allowerasing
  #             # Install kubectl
  #             sudo curl -o /usr/local/bin/kubectl -LO "https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.3/2025-04-17/bin/linux/amd64/kubectl"
  #             sudo chmod +x /usr/local/bin/kubectl

  #             # Enable kubectl bash completion
  #             echo "source <(kubectl completion bash)" | sudo tee -a /etc/bashrc
  #             curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
  #             chmod 700 get_helm.sh
  #             ./get_helm.sh
  #             sudo yum install -y yum-utils
  #             sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
  #             sudo yum -y install terraform
  #             EOF
  tags = {
    Name = "bastion-host"
  }


}

