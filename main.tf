provider "aws" {
  region = var.region
}

# terraform {
#   backend "s3" {
#     bucket = "mydeployment-s3-bucket-shared-private"
#     key    = "terraform.tfstate"
#     region = "ap-south-1"
#   }
# }

module "s3_bucket" {
  source = "clouddrove/s3/aws"

  name        = "mydeployment-s3-bucket"
  environment = "shared"
  attributes  = ["private"]
  label_order = ["name", "environment"]

  versioning = true
  acl        = "private"
}

module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "0.15.1"

  name        = "vaibhav-deployment"
  environment = var.environment
  label_order = var.label_order
  cidr_block  = var.vpc_cidr_block
}

module "subnets" {
  source  = "clouddrove/subnet/aws"
  version = "0.15.3"

  name        = "vaibhav-deployment"
  environment = var.environment
  label_order = var.label_order

  nat_gateway_enabled = true
  single_nat_gateway  = true

  availability_zones              = var.availability_zones
  vpc_id                          = module.vpc.vpc_id
  type                            = var.type
  igw_id                          = module.vpc.igw_id
  cidr_block                      = module.vpc.vpc_cidr_block
  ipv6_cidr_block                 = module.vpc.ipv6_cidr_block
  assign_ipv6_address_on_creation = var.assign_ipv6_address_on_creation
}



module "keypair" {
  source  = "clouddrove/keypair/aws"
  version = "1.0.1"

  public_key      = var.public_key
  key_name        = "vaibhav-deployment-shared"
  environment     = var.environment
  label_order     = var.label_order
  enable_key_pair = true
}


module "ssh" {
  source      = "clouddrove/security-group/aws"
  version     = "1.0.1"
  name        = "ssh"
  environment = var.environment
  label_order = var.label_order

  vpc_id        = module.vpc.vpc_id
  allowed_ip    = [module.vpc.vpc_cidr_block, "10.0.0.0/16"]
  allowed_ports = [22]
}


module "http-https" {
  source      = "clouddrove/security-group/aws"
  version     = "1.0.1"
  name        = "http-https"
  environment = var.environment
  label_order = var.label_order

  vpc_id        = module.vpc.vpc_id
  allowed_ip    = [module.vpc.vpc_cidr_block, "10.0.0.0/16"]
  allowed_ports = [80, 443]
}



module "ec2" {
  source  = "clouddrove/ec2/aws"
  version = "1.0.1"

  environment = var.environment
  label_order = var.label_order

  #instance
  name                    = "terraform-infra"
  instance_enabled        = true
  instance_count          = 3
  ami                     = var.ec2_ami
  instance_type           = var.ec2_instance_type
  monitoring              = false
  tenancy                 = "default"
  disable_api_termination = true

  #Networking
  vpc_security_group_ids_list = [module.ssh.security_group_ids]
  subnet_ids                  = tolist(module.subnets.private_subnet_id)
  assign_eip_address          = false
  associate_public_ip_address = false

  #Keypair
  key_name = module.keypair.name

  #IAM
  instance_profile_enabled = true

  #Root Volume
  root_block_device = [
    {
      volume_type           = "gp3"
      volume_size           = 30
      delete_on_termination = true
    #   kms_key_id            = module.kms_key.key_arn
    }
  ]

  #Tags
  instance_tags = { "snapshot" = false }

  # Metadata
  metadata_http_tokens_required        = "optional"
  metadata_http_endpoint_enabled       = "enabled"
  metadata_http_put_response_hop_limit = 2

}
