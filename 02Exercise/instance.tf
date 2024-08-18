resource "aws_instance" "ex02-inst" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t2.micro"
  availability_zone      = var.ZONE1
  key_name               = "18TerFrmKey"
  subnet_id              = "subnet-0d6de4f0e7a758d45"
  vpc_security_group_ids = ["sg-011080c64a370f323"]
  tags = {
    Name    = "Ecercise02-Instance"
    Project = "Exercise02"
  }
}