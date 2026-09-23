output "vpc_id" {
  description = "ID of the VPC hosting the backed-up workloads."
  value       = aws_vpc.main.id
}

output "web_server_instance_id" {
  description = "Instance ID of the web server."
  value       = aws_instance.web_server.id
}

output "sql_server_instance_id" {
  description = "Instance ID of the SQL server."
  value       = aws_instance.sql_server.id
}

output "shared_file_storage_id" {
  description = "ID of the shared EFS file system."
  value       = aws_efs_file_system.shared_file_storage.id
}

output "web_block_storage_id" {
  description = "ID of the EBS volume attached to the web server."
  value       = aws_ebs_volume.web_block_storage.id
}

output "sql_block_storage_id" {
  description = "ID of the EBS volume attached to the SQL server."
  value       = aws_ebs_volume.sql_block_storage.id
}

output "data_lake_bucket_name" {
  description = "Name of the S3 bucket storing raw data lake data."
  value       = aws_s3_bucket.data_lake_raw.bucket
}

output "backup_vault_name" {
  description = "Name of the AWS Backup vault storing recovery points."
  value       = aws_backup_vault.main.name
}

output "backup_plan_id" {
  description = "ID of the AWS Backup plan."
  value       = aws_backup_plan.main.id
}
