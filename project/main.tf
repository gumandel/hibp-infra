module "vpc" {
  source         = "./modules/vpc"
  project_name   = var.project_name
  project_region = var.project_region
}

module "ssm" {
  source      = "./modules/ssm"
  environment = var.environment
}

module "loadbalancer" {
  source   = "./modules/loadbalancer"
  vpc_id   = module.vpc.vpc_id
  sn_pub01 = module.vpc.sn_pub01
  sn_pub02 = module.vpc.sn_pub02
}

module "frontend_backend" {
  source                    = "./modules/compute"
  public_subnets            = [module.vpc.sn_pub01, module.vpc.sn_pub02] # 2 AZs
  private_subnets           = [module.vpc.sn_priv01, module.vpc.sn_priv02]
  environment               = var.environment
  iam_instance_profile_name = module.ssm.iam_instance_profile_name
  vpc_id                    = module.vpc.vpc_id
}

module "database" {
  source          = "./modules/database"
  private_subnets = [module.vpc.sn_priv01, module.vpc.sn_priv02] # Subnets privadas
  vpc_id          = module.vpc.vpc_id
}

module "cache" {
  source     = "./modules/cache"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = [module.vpc.sn_priv01, module.vpc.sn_priv02] # Redis em subnets privadas
}

module "observability" {
  source                    = "./modules/observability"
  repo_url                  = "https://github.com/gumandel/hibp-observability.git"
  backend_ips               = module.frontend_backend.backend_public_ips
  public_subnets            = [module.vpc.sn_pub01, module.vpc.sn_pub02]
  iam_instance_profile_name = module.ssm.iam_instance_profile_name
  vpc_id                    = module.vpc.vpc_id
}