terraform {
  backend "s3" {
    bucket = "tfrm07project"
    key    = "terraform/state-store"
    region = "us-east-2"
  }
}