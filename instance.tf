# put ssh-public key here , if you need ssh access

#generate with ssh-keygen -m PEM
resource "aws_key_pair" "ITKey" {
  key_name   = "kd"
  public_key = file("ec2_instance_key.pub")
}

data "template_file" "startup" {
  template = file("ssm-agent-install.sh")
}

resource "aws_security_group" "allow_web" {
  name        = "webserver"
  vpc_id      = module.vpc.vpc_id
  description = "Allows access to Web Port"
  #allow http 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # allow https
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    stack = "test"
  }
  lifecycle {
    create_before_destroy = true
  }
} #security group ends here

resource "aws_instance" "ec2" {
  depends_on = [
    module.vpc
  ]
  ami                    = "ami-0d09654d0a20d3ae2"
  instance_type          = "t3.nano"
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  iam_instance_profile   = aws_iam_instance_profile.dev-resources-iam-profile.name
  key_name               = aws_key_pair.ITKey.key_name
  root_block_device {
    delete_on_termination = true
    volume_type           = "gp2"
    volume_size           = 20
  }
  tags = {
    Name  = "test-ec2"
    stack = "test"
  }
  user_data = data.template_file.startup.rendered
}
