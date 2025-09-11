output "primary_endpoint" {
  value = aws_db_instance.postgres_primary.endpoint
}

output "replica_endpoints" {
  value = aws_db_instance.postgres_replica[*].endpoint
}