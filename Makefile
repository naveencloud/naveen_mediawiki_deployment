# Makefile to kickoff terraform.
# ####################################################
#

# # Before we start test that we have the mandatory executables available
	EXECUTABLES = git terraform
	K := $(foreach exec,$(EXECUTABLES),\
		$(if $(shell which $(exec)),some string,$(error "No $(exec) in PATH, consider apt-get install $(exec)")))


.PHONY: plan

first-run:
	@echo "initialize remote state file"
	cd layers/$(LAYER) && \
	terraform init


init:
	@echo "initialize remote state file"
	cd layers/$(LAYER) && \
	terraform workspace select $(WORKSPACE) || terraform workspace new $(WORKSPACE) && \
	terraform init

validate: init
	@echo "running terraform validate"
	cd layers/$(LAYER) && \
	terraform validate -no-color

plan: validate
	@echo "running terraform plan"
	cd layers/$(LAYER) && \
	terraform plan -no-color

apply: plan
	@echo "running terraform apply"
	cd layers/$(LAYER) && \
	terraform apply -auto-approve -no-color

plan-destroy: validate
	@echo "running terraform plan -destroy"
	cd layers/$(LAYER) && \
	terraform plan -destroy -no-color

destroy: init
	@echo "running terraform destroy"
	cd layers/$(LAYER) && \
	terraform destroy -force -no-color
