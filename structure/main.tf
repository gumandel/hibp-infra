resource "aws_s3_bucket" "terraform_state" {
    bucket        = "${var.project_name}-terraform-state1"
    acl           = "private"
    force_destroy = true # Colocar false em ambiente de produção
    versioning {
      enabled = true
    }

    tags = {
        Name        = "${var.project_name}-terraform-state1"
        Environment = "infra"
    }
}