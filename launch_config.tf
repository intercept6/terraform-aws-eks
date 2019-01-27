locals {
  userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint "${aws_eks_cluster.eks-cluster.endpoint}" --b64-cluster-ca "${aws_eks_cluster.eks-cluster.certificate_authority.0.data}" "${aws_eks_cluster.eks-cluster.name}"
USERDATA
}

data "aws_ami" "eks-node" {
  most_recent = true
  owners      = ["602401143452"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${local.cluster_version}-*"]
  }
}

data "aws_ami" "eks-gpu-node" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["amazon-eks-gpu-node-${local.cluster_version}-*"]
  }
}

resource "aws_launch_configuration" "eks-lc" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.eks-node-role-profile.id}"
  image_id                    = "${data.aws_ami.eks-node.image_id}"
  instance_type               = "t3.medium"
  name_prefix                 = "eks-node"
  key_name                    = "${var.key_name}"
  enable_monitoring           = false

  root_block_device {
    volume_type = "gp2"
    volume_size = "50"
  }

  security_groups  = ["${aws_security_group.cluster-nodes.id}"]
  user_data_base64 = "${base64encode(local.userdata)}"

  lifecycle {
    create_before_destroy = true
  }
}
