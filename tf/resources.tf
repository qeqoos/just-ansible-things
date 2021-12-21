resource "aws_key_pair" "key" {
    key_name = "testkey"
    public_key = file("/home/pavel/.ssh/ecs-instance-key.pub")
}

data "aws_ami" "amazon-linux-ami" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*"]
  }
}

data "aws_ami" "ubuntu-ami" {
  most_recent = true
  owners = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "amazon_linux" {
  ami = data.aws_ami.amazon-linux-ami.id
  instance_type = "t2.micro"
  count = 2
  key_name = aws_key_pair.key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.mySG.id]
  subnet_id                   = aws_subnet.subnet1.id
  depends_on = [ aws_route_table_association.rtass ]

  tags = {
    "Name" = "ansible-agent-${count.index+1}"
    "Env" = count.index == 0 ? "dev" : "prod"
    "Project" = "Middle"
  }
}


resource "aws_instance" "ubuntu" {
  ami = data.aws_ami.ubuntu-ami.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.mySG.id]
  subnet_id                   = aws_subnet.subnet1.id
  depends_on = [ aws_route_table_association.rtass ]

  tags = {
    "Name" = "ansible-agent-ubuntu"
    "Env" = "test"
    "Project" = "Middle"
  }
}