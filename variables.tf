variable "project_name" {
  description = "Project name used as prefix for all resources."
  type        = string
  default     = "floci-backup"
}

variable "aws_region" {
  description = "AWS region (simulated by floci)."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC hosting the backed-up workloads."
  type        = string
  default     = "10.60.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the single public subnet."
  type        = string
  default     = "10.60.1.0/24"
}

variable "instance_type" {
  description = "Instance type used by the web and SQL server instances."
  type        = string
  default     = "t3.micro"
}

variable "ebs_volume_size" {
  description = "Size in GiB of each EBS block storage volume."
  type        = number
  default     = 20
}

variable "backup_schedule" {
  description = "Cron expression controlling when the backup plan runs."
  type        = string
  default     = "cron(0 5 * * ? *)"
}

variable "backup_retention_days" {
  description = "Number of days recovery points are retained before deletion."
  type        = number
  default     = 30
}
