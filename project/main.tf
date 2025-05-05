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
  sn_pub01_id = module.vpc.sn_pub01_id
  sn_pub02_id = module.vpc.sn_pub02_id
}

module "frontend_backend" {
  source                    = "./modules/compute"
  public_subnets            = [module.vpc.sn_pub01_id, module.vpc.sn_pub02_id] # 2 AZs
  private_subnets           = [module.vpc.sn_priv01_id, module.vpc.sn_priv02_id]
  environment               = var.environment
  iam_instance_profile_name = module.ssm.iam_instance_profile_name
  vpc_id                    = module.vpc.vpc_id
}

module "database" {
  source          = "./modules/database"
  private_subnets = [module.vpc.sn_priv01_id, module.vpc.sn_priv02_id] # Subnets privadas
  vpc_id          = module.vpc.vpc_id
}

module "cache" {
  source     = "./modules/cache"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = [module.vpc.sn_priv01_id, module.vpc.sn_priv02_id] # Redis em subnets privadas
}

module "observability" {
  source                    = "./modules/observability"
  repo_url                  = "https://github.com/gumandel/hibp-observability.git"
  backend_ips               = module.frontend_backend.backend_public_ips
  public_subnets            = [module.vpc.sn_pub01_id, module.vpc.sn_pub02_id]
  iam_instance_profile_name = module.ssm.iam_instance_profile_name
  vpc_id                    = module.vpc.vpc_id
}