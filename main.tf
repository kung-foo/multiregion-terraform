module "cdn-us-east-1" {
  source        = "./cdn"
  region        = "us-east-1"
  instance_type = "t3.micro"
}

module "cdn-us-east-2" {
  source = "./cdn"
  region = "us-east-2"
}

module "cdn-us-west-1" {
  source = "./cdn"
  region = "us-west-1"
}

module "cdn-us-west-2" {
  source = "./cdn"
  region = "us-west-2"
}

module "cdn-ca-central-1" {
  source = "./cdn"
  region = "ca-central-1"
}

module "cdn-eu-west-1" {
  source = "./cdn"
  region = "eu-west-1"
}

module "cdn-eu-west-2" {
  source = "./cdn"
  region = "eu-west-2"
}

module "cdn-eu-west-3" {
  source = "./cdn"
  region = "eu-west-3"
}

module "cdn-eu-central-1" {
  source = "./cdn"
  region = "eu-central-1"
}

module "cdn-eu-south-1" {
  source = "./cdn"
  region = "eu-south-1"
}

module "cdn-eu-north-1" {
  source = "./cdn"
  region = "eu-north-1"
}

module "cdn-ap-northeast-1" {
  source = "./cdn"
  region = "ap-northeast-1"
}

module "cdn-ap-northeast-2" {
  source = "./cdn"
  region = "ap-northeast-2"
}

module "cdn-ap-southeast-1" {
  source = "./cdn"
  region = "ap-southeast-1"
}

module "cdn-ap-southeast-2" {
  source = "./cdn"
  region = "ap-southeast-2"
}

module "cdn-ap-south-1" {
  source = "./cdn"
  region = "ap-south-1"
}

module "cdn-sa-east-1" {
  source = "./cdn"
  region = "sa-east-1"
}

module "cdn-af-south-1" {
  source = "./cdn"
  region = "af-south-1"
}