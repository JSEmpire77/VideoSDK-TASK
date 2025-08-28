## reference : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile
resource "aws_iam_role" "ssm_assume_role" {
  name = var.role

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_managed_policy" {
  role       = aws_iam_role.ssm_assume_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"  // From AWS IAM
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = var.instance_profile
  role = aws_iam_role.ssm_assume_role.name
}