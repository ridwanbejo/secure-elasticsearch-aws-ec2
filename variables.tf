variable "project" {
  description = "Project Name"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "region_code" {
  description = "AWS Region Code"
  type        = string
}


variable "az" {
  description = "AWS Availibility Zone for choosen Region"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the VPC Subnet"
  type        = string
}

variable "public_key_path" {
  description = "Path to your public key for EC2 instance"
  type        = string
}

variable "private_key_path" {
  description = "Path to your private key for EC2 instance"
  type        = string
}
