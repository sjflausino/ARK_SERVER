provider "aws" {
  region = var.aws_region 
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_key_pair" "ark_key" {
  key_name   = var.ssh_key_name
  public_key = file(var.ssh_public_key)
}
