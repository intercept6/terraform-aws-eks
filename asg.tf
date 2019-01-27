resource "aws_autoscaling_group" "eks-asg" {
  name                 = "EKS cluster nodes"
  desired_capacity     = "${var.num_subnets}"
  launch_configuration = "${aws_launch_configuration.eks-lc.id}"
  max_size             = "${var.num_subnets}"
  min_size             = "${var.num_subnets}"

  vpc_zone_identifier = ["${aws_subnet.subnet.*.id}"]

  tag {
    key                 = "Name"
    value               = "${local.base_name}-nodes"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${local.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "${var.project}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
