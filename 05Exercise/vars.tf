variable "REGION" {
  default = "us-east-2"
}

variable "ZONE1" {
  default = "us-east-2a"
}

variable "AMIS" {
  type = map(any)
  default = {
    us-east-2 = "ami-05c3dc660cb6907f0"
    us-east-1 = "ami-0ae8f15ae66fe8cda "
  }
}

variable "USER" {
  default = "ec2-user"
}