#provider variables
variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

#VPC and Subnet variables
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "Map public IP on launch for the subnet"
  type        = bool
  default     = true
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.0.1/24"]
}

# EC2 instance variables
variable "aws_instance_size" {
  type        = map(string)
  description = "Tamanhos viáveis de instância"
  default = {
    small  = "t3.micro"
    medium = "t3.medium"
    large  = "t3-large"
  }
}

# Tagging variables
variable "company" {
  description = "Company name for tagging resources"
  type        = string
  default     = "abraao"
}

variable "project" {
  description = "value for project tag"
  type        = string
}