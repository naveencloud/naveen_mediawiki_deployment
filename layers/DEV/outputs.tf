#Exported output


output "rds-address" {
  value = "ca-cng-dev-wow-rds.cayjpmzbzlzg.eu-central-1.rds.amazonaws.com"
}

output "rds-port" {
  value = 3306
}

output "rds-name" {
  value = "ca-cng-dev-wow-rds"
}

output "orch_tabledata_api" {
  value = "https://dev-orch-yde-dp-execution-api.eu-central-1.amazonaws.com/dev_orch/dpiexecution"
}

output "ecs_memory" {
  value = var.memory
}

output "ecr_repository_repository_url" {
  value = module.le_packet_process_ecr_repo.core_ecr_repository_url
}

output "le_packet_process_sqs_queue_id" {
  value = "ca-cng-${var.environment}-le-processing-unit-sqs"
}

output "le_elasticsearch_endpoint" {
  /*value = "https://vpc-lestrategy1-d5tribhfe2r5johfpzjgyw6sfm.eu-central-1.es.amazonaws.com"*/
  value = module.le_packet_process_elastic_search_service.elastic_search_domain_endpoint
}
output "le_elasticsearch_endpoint_core" {
  value = module.le_packet_process_elastic_search_service.elastic_search_domain_endpoint
}