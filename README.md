# AWS Project: Managed Backup Solution

Centralized, policy-driven backup with Floci and Terraform:

1. a web server and a SQL server instance run the workloads;
2. their data lives in shared file storage (EFS), dedicated block storage (EBS), and a data lake raw bucket (S3);
3. AWS Backup applies one plan and schedule across all of them;
4. recovery points land in a single backup vault, ready to restore.

## Prerequisites

- Docker
- Terraform 1.5+
- AWS CLI

## Start Floci

```bash
docker compose up -d
```

## Apply Terraform

```bash
terraform init
terraform apply
```

## Architecture

<div style="margin: 1.5rem 0 1rem; padding: 1.25rem; border: 1px solid rgba(45,49,66,0.14); border-radius: 12px; background: #f5f5f5; overflow-x: auto;">
<div style="display: flex; align-items: center; gap: 0.65rem; margin-bottom: 0.45rem;">
	<img src="../icons/Architecture-Group-Icons_07312026/AWS-Cloud-logo_32.svg" alt="AWS cloud icon" style="width: 30px; height: 30px; display: block;" />
	<div style="font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.72rem; letter-spacing: 0.16em; text-transform: uppercase; color: #4f5d75;">AWS Architecture</div>
</div>
<div style="font-family: 'Instrument Serif', Georgia, serif; font-size: 1.85rem; line-height: 1.1; color: #2d3142; margin-bottom: 0.35rem;">Managed Backup Solution</div>
<div style="font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.72rem; letter-spacing: 0.14em; text-transform: uppercase; color: #4f5d75; margin-bottom: 1rem;">Web and SQL server instances write to shared file, block, and data lake storage, all backed up by a single AWS Backup plan into one vault</div>

<table style="width: 100%; min-width: 980px; border-collapse: collapse; table-layout: fixed;">
	<tr>
		<td colspan="2" style="text-align: center; padding-bottom: 0.5rem;">
			<div style="background: #ffffff; border: 1px solid rgba(45,49,66,0.18); border-radius: 12px; padding: 0.7rem 1rem; display: inline-flex; align-items: center; gap: 0.55rem;">
				<img src="../icons/Resource-Icons_07312026/Res_Compute/Res_Amazon-EC2_Instance_48.svg" alt="EC2 icon" style="width: 34px; height: 34px; display: block;" />
				<div>
					<div style="display: inline-block; font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.6rem; letter-spacing: 0.08em; color: #4f5d75; border: 1px solid rgba(79,93,117,0.35); border-radius: 4px; padding: 0.08rem 0.3rem; margin-bottom: 0.15rem;">EC2</div>
					<div style="font-family: 'Geist', system-ui, sans-serif; font-size: 0.85rem; font-weight: 600; color: #2d3142;">Web Server Instance</div>
				</div>
			</div>
		</td>
		<td style="text-align: center; padding-bottom: 0.5rem;">
			<div style="background: #ffffff; border: 1px solid rgba(45,49,66,0.18); border-radius: 12px; padding: 0.7rem 1rem; display: inline-flex; align-items: center; gap: 0.55rem;">
				<img src="../icons/Resource-Icons_07312026/Res_Compute/Res_Amazon-EC2_Instance_48.svg" alt="EC2 icon" style="width: 34px; height: 34px; display: block;" />
				<div>
					<div style="display: inline-block; font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.6rem; letter-spacing: 0.08em; color: #4f5d75; border: 1px solid rgba(79,93,117,0.35); border-radius: 4px; padding: 0.08rem 0.3rem; margin-bottom: 0.15rem;">EC2</div>
					<div style="font-family: 'Geist', system-ui, sans-serif; font-size: 0.85rem; font-weight: 600; color: #2d3142;">SQL Server Instance</div>
				</div>
			</div>
		</td>
		<td></td>
	</tr>
	<tr>
		<td colspan="4" style="padding: 0.1rem 0 0.3rem;">
			<div style="display: flex; justify-content: space-between; padding: 0 12%;">
				<div style="width: 1px; height: 20px; background: #eb6c36; position: relative;">
					<div style="position: absolute; bottom: -1px; left: -4px; width: 0; height: 0; border-top: 8px solid #eb6c36; border-left: 5px solid transparent; border-right: 5px solid transparent;"></div>
				</div>
				<div style="width: 1px; height: 20px; background: #eb6c36; position: relative;">
					<div style="position: absolute; bottom: -1px; left: -4px; width: 0; height: 0; border-top: 8px solid #eb6c36; border-left: 5px solid transparent; border-right: 5px solid transparent;"></div>
				</div>
				<div style="width: 1px; height: 20px; background: #eb6c36; position: relative;">
					<div style="position: absolute; bottom: -1px; left: -4px; width: 0; height: 0; border-top: 8px solid #eb6c36; border-left: 5px solid transparent; border-right: 5px solid transparent;"></div>
				</div>
				<div style="width: 1px; height: 20px;"></div>
			</div>
		</td>
	</tr>
	<tr>
		<td style="vertical-align: top; width: 25%; padding: 0 0.4rem;">
			<div style="background: #ffffff; border: 1px solid rgba(45,49,66,0.18); border-radius: 12px; padding: 0.85rem; min-height: 150px;">
				<div style="display: flex; justify-content: center; margin-bottom: 0.55rem;">
					<img src="../icons/Resource-Icons_07312026/Res_Storage/Res_Amazon-Elastic-File-System_File-System_48.svg" alt="EFS icon" style="width: 38px; height: 38px; display: block;" />
				</div>
				<div style="display: inline-block; font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.62rem; letter-spacing: 0.08em; color: #4f5d75; border: 1px solid rgba(79,93,117,0.35); border-radius: 4px; padding: 0.1rem 0.35rem; margin-bottom: 0.45rem;">EFS</div>
				<div style="font-family: 'Geist', system-ui, sans-serif; font-size: 0.92rem; font-weight: 600; color: #2d3142; text-align: center;">Shared File Storage</div>
			</div>
		</td>
		<td style="vertical-align: top; width: 25%; padding: 0 0.4rem;">
			<div style="background: #ffffff; border: 1px solid rgba(45,49,66,0.18); border-radius: 12px; padding: 0.85rem; min-height: 150px;">
				<div style="display: flex; justify-content: center; margin-bottom: 0.55rem;">
					<img src="../icons/Resource-Icons_07312026/Res_Storage/Res_Amazon-Elastic-Block-Store_Volume_48.svg" alt="EBS icon" style="width: 38px; height: 38px; display: block;" />
				</div>
				<div style="display: inline-block; font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.62rem; letter-spacing: 0.08em; color: #4f5d75; border: 1px solid rgba(79,93,117,0.35); border-radius: 4px; padding: 0.1rem 0.35rem; margin-bottom: 0.45rem;">EBS</div>
				<div style="font-family: 'Geist', system-ui, sans-serif; font-size: 0.92rem; font-weight: 600; color: #2d3142; text-align: center;">Block Storage</div>
			</div>
		</td>
		<td style="vertical-align: top; width: 25%; padding: 0 0.4rem;">
			<div style="background: #ffffff; border: 1px solid rgba(45,49,66,0.18); border-radius: 12px; padding: 0.85rem; min-height: 150px;">
				<div style="display: flex; justify-content: center; margin-bottom: 0.55rem;">
					<img src="../icons/Resource-Icons_07312026/Res_Storage/Res_Amazon-Elastic-Block-Store_Volume_48.svg" alt="EBS icon" style="width: 38px; height: 38px; display: block;" />
				</div>
				<div style="display: inline-block; font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.62rem; letter-spacing: 0.08em; color: #4f5d75; border: 1px solid rgba(79,93,117,0.35); border-radius: 4px; padding: 0.1rem 0.35rem; margin-bottom: 0.45rem;">EBS</div>
				<div style="font-family: 'Geist', system-ui, sans-serif; font-size: 0.92rem; font-weight: 600; color: #2d3142; text-align: center;">Block Storage</div>
			</div>
		</td>
		<td style="vertical-align: top; width: 25%; padding: 0 0.4rem;">
			<div style="background: #ffffff; border: 1px solid rgba(45,49,66,0.18); border-radius: 12px; padding: 0.85rem; min-height: 150px;">
				<div style="display: flex; justify-content: center; margin-bottom: 0.55rem;">
					<img src="../icons/Resource-Icons_07312026/Res_Storage/Res_Amazon-Simple-Storage-Service_Bucket_48.svg" alt="S3 icon" style="width: 38px; height: 38px; display: block;" />
				</div>
				<div style="display: inline-block; font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.62rem; letter-spacing: 0.08em; color: #4f5d75; border: 1px solid rgba(79,93,117,0.35); border-radius: 4px; padding: 0.1rem 0.35rem; margin-bottom: 0.45rem;">S3</div>
				<div style="font-family: 'Geist', system-ui, sans-serif; font-size: 0.92rem; font-weight: 600; color: #2d3142; text-align: center;">Data Lake Raw Data</div>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="4" style="padding: 0.35rem 12% 0;">
			<div style="height: 1px; background: #eb6c36; position: relative;">
				<div style="position: absolute; left: 50%; top: -1px; width: 0; height: 0; transform: translateX(-50%); border-top: 8px solid #eb6c36; border-left: 5px solid transparent; border-right: 5px solid transparent;"></div>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="4" style="text-align: center; padding-top: 0.5rem;">
			<div style="display: inline-flex; align-items: center; gap: 0.9rem;">
				<div style="background: #ffffff; border: 1px solid rgba(45,49,66,0.18); border-radius: 12px; padding: 0.85rem 1.2rem; display: inline-flex; align-items: center; gap: 0.6rem;">
					<img src="../icons/Resource-Icons_07312026/Res_Storage/Res_AWS-Backup_Backup-Plan_48.svg" alt="AWS Backup icon" style="width: 36px; height: 36px; display: block;" />
					<div>
						<div style="display: inline-block; font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.62rem; letter-spacing: 0.08em; color: #4f5d75; border: 1px solid rgba(79,93,117,0.35); border-radius: 4px; padding: 0.1rem 0.35rem; margin-bottom: 0.15rem;">AWS BACKUP</div>
						<div style="font-family: 'Geist', system-ui, sans-serif; font-size: 0.9rem; font-weight: 600; color: #2d3142;">Daily Backup Plan</div>
					</div>
				</div>
				<div style="display: flex; align-items: center; width: 48px;">
					<div style="height: 1px; width: 100%; background: #eb6c36; position: relative;">
						<div style="position: absolute; right: -1px; top: -4px; width: 0; height: 0; border-left: 8px solid #eb6c36; border-top: 5px solid transparent; border-bottom: 5px solid transparent;"></div>
					</div>
				</div>
				<div style="background: #ffffff; border: 1px solid rgba(45,49,66,0.18); border-radius: 12px; padding: 0.85rem 1.2rem; display: inline-flex; align-items: center; gap: 0.6rem;">
					<img src="../icons/Resource-Icons_07312026/Res_Storage/Res_AWS-Backup_Backup-Vault_48.svg" alt="Backup Vault icon" style="width: 36px; height: 36px; display: block;" />
					<div>
						<div style="display: inline-block; font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.62rem; letter-spacing: 0.08em; color: #4f5d75; border: 1px solid rgba(79,93,117,0.35); border-radius: 4px; padding: 0.1rem 0.35rem; margin-bottom: 0.15rem;">BACKUP VAULT</div>
						<div style="font-family: 'Geist', system-ui, sans-serif; font-size: 0.9rem; font-weight: 600; color: #2d3142;">Recovery Points</div>
					</div>
				</div>
			</div>
		</td>
	</tr>
</table>

<div style="font-family: 'Geist', system-ui, sans-serif; font-size: 0.95rem; font-weight: 600; color: #2d3142; text-align: center; margin-top: 1rem;">AWS project: EC2, EFS, EBS, and S3 all resolve into one AWS Backup plan writing recovery points to a single vault</div>
</div>

## Test the backup plan

Check that the plan, vault, and selection were created:

```bash
export ENDPOINT=http://localhost:4566

aws --endpoint-url "$ENDPOINT" backup list-backup-plans
aws --endpoint-url "$ENDPOINT" backup list-backup-vaults
aws --endpoint-url "$ENDPOINT" backup list-backup-selections \
  --backup-plan-id "$(terraform output -raw backup_plan_id)"
```

Trigger an on-demand backup job for the data lake bucket and follow it:

```bash
JOB_ID=$(aws --endpoint-url "$ENDPOINT" backup start-backup-job \
  --backup-vault-name "$(terraform output -raw backup_vault_name)" \
  --resource-arn "$(terraform output -raw data_lake_bucket_name | xargs -I{} echo arn:aws:s3:::{})" \
  --iam-role-arn "$(aws --endpoint-url "$ENDPOINT" iam get-role --role-name floci-backup-backup-role --query 'Role.Arn' --output text)" \
  --query 'BackupJobId' --output text)

aws --endpoint-url "$ENDPOINT" backup describe-backup-job --backup-job-id "$JOB_ID"
```

If you want to follow the execution, watch the Floci container logs:

```bash
docker compose logs -f floci
```

## Clean up

```bash
terraform destroy
docker compose down
```
