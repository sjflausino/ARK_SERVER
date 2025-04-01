# ARK: Survival Evolved Server on AWS (via Terraform)

This repository sets up an ARK: Survival Evolved server on an AWS EC2 instance using Terraform. It also configures automated backups using AWS S3, installs SteamCMD, and manages the server with RCON.

## Requirements

- **Terraform**: Version 1.x or higher
- **AWS CLI**: Version 2.x or higher
- **AWS Account** with IAM user permissions for creating EC2, S3, IAM Key Pairs, etc.

## Quick Start

### 1. Clone this Repository

```bash
git clone https://github.com/sjflausino/ark-server.git
cd ark-server
```

### 2. Set Up AWS Credentials

Ensure your AWS CLI is configured with appropriate credentials. Run the following:

```bash
aws configure
```

Enter your AWS Access Key, Secret Key, region, and output format.

### 3. Customize Terraform Variables

Edit the `terraform.tfvars` file to set your variables:

```hcl
aws_region       = "us-east-1"           # AWS region
s3_bucket_name   = "ark-server-backup"   # S3 bucket name for backups
ami_id           = "ami-0c55b159cbfafe1f0" # AWS AMI ID (Ubuntu or other)
instance_type    = "t3.medium"           # EC2 instance type
ssh_key_name     = "ark-server-key"      # SSH key name
ssh_public_key   = "ark-server-key.pub"  # Path to your SSH public key
```

### 4. Initialize Terraform

Run the following to initialize your Terraform working directory:

```bash
terraform init
```

### 5. Apply the Terraform Configuration

Now, apply the Terraform configuration to create the EC2 instance, S3 bucket, and other resources:

```bash
terraform apply -auto-approve
```

### 6. Connect to the EC2 Instance

Once the resources are created, you can SSH into your EC2 instance:

```bash
ssh -i ark-server-key.pem ubuntu@<YOUR_EC2_PUBLIC_IP>
```

Replace `<YOUR_EC2_PUBLIC_IP>` with the actual public IP of your EC2 instance.

### 7. Install ARK: Survival Evolved Server

Run the following command to install the ARK server using SteamCMD:

```bash
steamcmd +login anonymous +force_install_dir /home/ubuntu/ark-server +app_update 376030 validate +quit
```

### 8. Starting the ARK Server

Start the ARK server with the following command:

```bash
/home/ubuntu/ark-server/ShooterGame/Binaries/Linux/ShooterGameServer TheIsland?listen -server -log &
```

### 9. Set Up Automated Backups (Optional)

Backups are configured to run daily at 3:00 AM. If you'd like to adjust the backup schedule, update the cron job by editing:

```bash
crontab -e
```

The cron job should look like this:

```bash
0 3 * * * tar -czvf /home/ubuntu/ark-backup.tar.gz /home/ubuntu/ark-server && aws s3 cp /home/ubuntu/ark-backup.tar.gz s3://${var.s3_bucket_name}/
```

### 10. RCON Setup

To list players or manage the server, you'll need to enable RCON in `GameUserSettings.ini`. Update the file with the following:

```ini
RCONEnabled=True
RCONPort=32330
ServerAdminPassword=your_rcon_password
```

Use `mcrcon` to connect:

```bash
mcrcon -H 127.0.0.1 -P 32330 -p your_rcon_password "listplayers"
```

### 11. Terminating Resources

When you're done, destroy the resources created by Terraform to avoid unwanted charges:

```bash
terraform destroy -auto-approve
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- ARK: Survival Evolved Server by Studio Wildcard
- Terraform by HashiCorp
- SteamCMD by Valve Corporation
```

---

### **Key Updates:**
- **Terraform Setup**: Instructions to configure `terraform.tfvars` for variables.
- **SteamCMD Installation**: Steps to install SteamCMD and use it for setting up the ARK server.
- **Backup**: Configuring automated backups with cron jobs and AWS S3.
- **RCON**: Steps for using RCON to manage the server.

You can now clone this repository, configure your AWS credentials, and deploy the server! Let me know if you need any further adjustments. 🚀