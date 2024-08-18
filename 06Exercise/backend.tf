terraform {
  backend "s3" {
    bucket = "18trfm06"
    key    = "terraform/backend"
    region = "us-east-2"
  }
}