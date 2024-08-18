terraform {
  backend "s3" {
    bucket = "18tfrm05exers3"
    key    = "terraform/backend"
    region = "us-east-2"
  }
}