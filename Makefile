# Configurações
BUCKET_NAME ?= hibp-infra-terraform-state
AWS_REGION ?= us-west-1

# Verifica e cria o bucket S3 se não existir
init-bucket:
	@echo "Verificando se o bucket $(BUCKET_NAME) existe..."
	@if ! aws s3api head-bucket --bucket $(BUCKET_NAME) 2>/dev/null; then \
		echo "Criando bucket $(BUCKET_NAME)..."; \
		aws s3api create-bucket --bucket $(BUCKET_NAME) --region $(AWS_REGION) --create-bucket-configuration LocationConstraint=$(AWS_REGION); \
		aws s3api put-bucket-versioning --bucket $(BUCKET_NAME) --versioning-configuration Status=Enabled; \
		aws s3api put-bucket-encryption --bucket $(BUCKET_NAME) --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'; \
		echo "Bucket criado com sucesso!"; \
	else \
		echo "Bucket $(BUCKET_NAME) já existe. Pulando criação..."; \
	fi

# Comando padrão: executa todos os passos
init: init-bucket

.PHONY: init init-bucket