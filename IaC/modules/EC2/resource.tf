# referance : https://stackoverflow.com/questions/70418145/how-to-access-key-value-pairs-stored-in-aws-parameter-store-using-terraform-scri
data "aws_ssm_parameter" "terra_key_public" {
  name = "/ssh/terra-key-public"
}

data "aws_ssm_parameter" "terra_key_private" {
  name = "/ssh/terra-key-private"
}

resource "aws_key_pair" "terra-key" {
  key_name   = "terra-key"
  public_key = data.aws_ssm_parameter.terra_key_public.value
}
#referance : https://www.cloudbolt.io/terraform-best-practices/terraform-dynamic-blocks/
resource "aws_security_group" "terra_sg" {
  name        = "TASK-master-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.port_module
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "basion-host" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_1
  vpc_security_group_ids = ["${aws_security_group.terra_sg.id}"]
  subnet_id              = var.public_subnet
  key_name               = aws_key_pair.terra-key.key_name
  iam_instance_profile   = var.iam

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = data.aws_ssm_parameter.terra_key_private.value #file("${path.module}/id_rsa") 
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "terra_key.pem"              # Local file
    destination = "/home/ubuntu/terra-key.pem" # Remote location
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /home/ubuntu/terra-key.pem"
    ]
  }

  tags = {
    Name = "TASK-Bastion_Host"
  }
}

resource "aws_instance" "master" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_2
  vpc_security_group_ids = ["${aws_security_group.terra_sg.id}"]
  subnet_id              = var.private_subnet
  key_name               = aws_key_pair.terra-key.key_name
  iam_instance_profile   = var.iam
  user_data              = base64encode(file("${path.module}/scripts/master.sh"))
  tags = {
    Name = "TASK-master-node"
  }
}

resource "aws_security_group" "terra_sg_2" {
  name        = "TASK-worker-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.port_module_2
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  ingress {
    from_port       = 30080
    to_port         = 30080
    protocol        = "tcp"
    security_groups = [var.lb_id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "terra_temp" {
  name_prefix   = "TASK-worker-lt-"
  image_id      = var.ami_id_2
  instance_type = var.instance_type_2
  key_name      = aws_key_pair.terra-key.key_name
  iam_instance_profile {
    name = var.iam
  }
  user_data = base64encode(file("${path.module}/scripts/worker.sh"))

  network_interfaces {
    security_groups             = [aws_security_group.terra_sg_2.id]
    subnet_id                   = var.private_subnet
    associate_public_ip_address = false
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "TASK-worker-node"
    }
  }
}