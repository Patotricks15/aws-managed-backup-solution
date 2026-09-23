# ─── Networking ───────────────────────────────────────────────────────────────

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-igw"
  })
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-subnet"
  })
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-rt"
  })
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "workloads" {
  name        = "${local.name_prefix}-workloads-sg"
  description = "Allow HTTP/SQL traffic to the web and SQL server instances, and NFS to EFS."
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SQL Server"
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "NFS to EFS"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-workloads-sg"
  })
}

# ─── Compute ──────────────────────────────────────────────────────────────────

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.workloads.id]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-web-server"
    Role = "web-server"
  })
}

resource "aws_instance" "sql_server" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.workloads.id]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-sql-server"
    Role = "sql-server"
  })
}

# ─── Storage ──────────────────────────────────────────────────────────────────

resource "aws_efs_file_system" "shared_file_storage" {
  creation_token = "${local.name_prefix}-shared-file-storage"
  encrypted      = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-shared-file-storage"
  })
}

resource "aws_efs_mount_target" "shared_file_storage" {
  file_system_id  = aws_efs_file_system.shared_file_storage.id
  subnet_id       = aws_subnet.main.id
  security_groups = [aws_security_group.workloads.id]
}

resource "aws_ebs_volume" "web_block_storage" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = var.ebs_volume_size
  type              = "gp3"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-web-block-storage"
  })
}

resource "aws_volume_attachment" "web_block_storage" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.web_block_storage.id
  instance_id = aws_instance.web_server.id
}

resource "aws_ebs_volume" "sql_block_storage" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = var.ebs_volume_size
  type              = "gp3"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-sql-block-storage"
  })
}

resource "aws_volume_attachment" "sql_block_storage" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.sql_block_storage.id
  instance_id = aws_instance.sql_server.id
}

resource "aws_s3_bucket" "data_lake_raw" {
  bucket = "${local.name_prefix}-data-lake-raw"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-data-lake-raw"
  })
}

resource "aws_s3_bucket_versioning" "data_lake_raw" {
  bucket = aws_s3_bucket.data_lake_raw.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ─── AWS Backup ───────────────────────────────────────────────────────────────

resource "aws_iam_role" "backup" {
  name = "${local.name_prefix}-backup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "backup.amazonaws.com" }
    }]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "backup_service" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_iam_role_policy_attachment" "backup_s3" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForS3Backup"
}

resource "aws_backup_vault" "main" {
  name = "${local.name_prefix}-vault"

  tags = local.common_tags
}

resource "aws_backup_plan" "main" {
  name = "${local.name_prefix}-plan"

  rule {
    rule_name         = "${local.name_prefix}-daily-rule"
    target_vault_name = aws_backup_vault.main.name
    schedule          = var.backup_schedule

    lifecycle {
      delete_after = var.backup_retention_days
    }
  }

  tags = local.common_tags
}

resource "aws_backup_selection" "main" {
  name         = "${local.name_prefix}-selection"
  plan_id      = aws_backup_plan.main.id
  iam_role_arn = aws_iam_role.backup.arn

  resources = [
    aws_instance.web_server.arn,
    aws_instance.sql_server.arn,
    aws_efs_file_system.shared_file_storage.arn,
    aws_ebs_volume.web_block_storage.arn,
    aws_ebs_volume.sql_block_storage.arn,
    aws_s3_bucket.data_lake_raw.arn,
  ]
}
