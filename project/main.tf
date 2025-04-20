module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
}

module "loadbalancer" {
  source   = "./modules/loadbalancer"
  vpc_id   = module.vpc.vpc_id
  sn_pub01 = module.vpc.sn_pub01
  sn_pub02 = module.vpc.sn_pub02
}

module "frontend" {
  source          = "./modules/compute"
  public_subnets  = [module.vpc.sn_pub01, module.vpc.sn_pub02] # 2 AZs
  private_subnets = [module.vpc.sn_priv01, module.vpc.sn_priv02]
}

module "database" {
  source = "./modules/database"
  private_subnets = [module.vpc.sn_priv01, module.vpc.sn_priv02] # Subnets privadas
  vpc_id = module.vpc.vpc_id
}

module "cache" {
  source     = "./modules/cache"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = [module.vpc.sn_priv01, module.vpc.sn_priv02] # Redis em subnets privadas
}