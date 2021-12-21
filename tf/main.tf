terraform {
  backend "local" {
    path = "/home/pavel/ansible/tf/tf_state"
  }
}

provider "aws" {
  region = "eu-central-1"
  profile = "tf_user"
}