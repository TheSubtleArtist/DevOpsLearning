variable "REGION" {
  default = "us-east-1"
}

variable "ZONE1" {
  default = "us-east-1b"
}

variable "AMIS" {
  type = map(any)
  default = {
    us-east-2 = "ami-0f5d333879b58a767"
    us-east-1 = "ami-0b1ca8b711f1d1fd7"
  }
}