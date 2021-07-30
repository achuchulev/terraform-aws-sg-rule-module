provider "aws" {
  region = "us-east-1"
}

module "test_sg" {
  source = "./modules/sg"
}
