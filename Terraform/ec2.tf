
#Security-group

resource "aws_security_group" "sg" {
  name   = "Devops-workflow-sg"
  vpc_id = aws_vpc.main.id

  ingress = []
  egress  = []
}

#Ec2-Creation

resource "aws_instance" "ins" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.large"
  key_name = "backend"

  tags = {
    Name = "Devops-workflow-trail"
  }
}
