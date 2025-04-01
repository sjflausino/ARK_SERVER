variable "aws_region" {
    description = "The AWS region to deploy resources in"
    type        = string
    default     = "sa-east-1"
}

variable "aws_access_key" {
    description = "The AWS access key for authentication"
    type        = string
    sensitive   = true
}

variable "aws_secret_key" {
    description = "The AWS secret key for authentication"
    type        = string
    sensitive   = true
}

variable "s3_bucket_name" {
    description = "The name of the S3 bucket for backups"
    type        = string
    default     = "ark-server-backup-bucket"
}

variable "ami_id" {
    description = "The AMI ID for the EC2 instance"
    type        = string
    default     = "ami-0d866da98d63e2b42"
}

variable "instance_type" {
    description = "The EC2 instance type"
    type        = string
    default     = "t3.medium"
}

variable "ssh_key_name" {
    description = "The name of the SSH key pair"
    type        = string
    default     = "ark-server-key"
}

variable "ssh_public_key" {
    description = "The public key file for SSH access"
    type        = string
    default     = "ark-server-key.pub"
}
