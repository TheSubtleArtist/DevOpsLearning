terraform {
  backend "s3" {
    bucket = "18trfm06"
    key    = "terraform/state"
    region = "us-east-2"
  }
}