provider "aws" {
  region = "us-east-1"
  #  access_key = ""
  #  secret_key = ""	
}

resource "aws_instance" "intro" {
  ami                    = "ami-0b1ca8b711f1d1fd7"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1b"
  subnet_id              = "subnet-0d6de4f0e7a758d45"
  key_name               = "18Terraformkey.pem"
  vpc_security_group_ids = ["sg-011080c64a370f323"]
  tags = {
    Name    = "Tutorial-Instance"
    Project = "Terraform-Tutorial"
  }
}