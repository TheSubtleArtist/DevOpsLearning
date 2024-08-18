resource "aws_key_pair" "dove-key2" {
  key_name   = "dovekey"
  public_key = file("dovekey.pub")
}

resource "aws_instance" "ex05-inst" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t2.micro"
  availability_zone      = var.ZONE1
  key_name               = aws_key_pair.dove-key2.key_name
  vpc_security_group_ids = ["sg-020c98cc025bcabd9"]
  tags = {
    Name    = "Exercise05-Instance"
    Project = "TerraformTutorial"
  }

  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }

  provisioner "remote-exec" {

    inline = [
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]
  }

  connection {
    user        = var.USER
    private_key = file("dovekey")
    host        = self.public_ip
  }
}

output "PublicIP" {
  value = aws_instance.ex05-inst.public_ip
}

output "PrivateIP" {
  value = aws_instance.ex05-inst.private_ip
}