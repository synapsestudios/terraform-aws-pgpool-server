variable "ami" {
  type        = string
  description = "AMI name of the pgpool image to use."
}

variable "hostname" {
  type        = string
  description = "Hostname of the pgpool server."
  default     = "pgpool"
}

variable "public_ssh_key" {
  type        = string
  description = "Public SSH key to use with pgpool server."
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC to deploy pgpool server on."
}

variable "subnet_id" {
  type        = string
  description = "ID of subnet to deploy pgpool server on."
}

variable "dns_zone" {
  type        = string
  description = "Name of the DNS zone to use with this deployment."
  default     = null
}

variable "dns_private_zone" {
  type        = bool
  description = "If true, a private DNS zone will be used."
  default     = false
}

variable "allow_cidr" {
  type        = list(string)
  description = "List of CIDR blocks allow to connect to pgpool server."
}

variable "database_security_group" {
  type        = string
  description = "ID of the security group attached to the database."
  default     = null
}

variable "database_ports" {
  type        = list(object({ port = number, description = string }))
  description = "List of TCP Port numbers to access databases."
  default     = [{ port = 5432, description = "PostgreSQL Access From PgPool" }]
}

variable "redis_security_group" {
  type        = string
  description = "ID of the security group attached to Reids / Elasticache."
  default     = null
}

variable "namespace" {
  type        = string
  description = "Determines naming convention of assets. Generally follows DNS naming convention."
}

variable "use_external_dns" {
  type        = bool
  description = "If true, this module will not create any Route53 DNS records."
  default     = false
}

variable "instance_type" {
  type        = string
  description = "EC2 Instance type to provision."
  default     = "t2.micro"
}

variable "iam_instance_profile" {
  type        = string
  description = " (Optional) The IAM Instance Profile to use with pgpool server."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the AWS resources."
}

# Root Block Device
variable "encrypted" {
  type        = bool
  description = "(Optional) Enable volume encryption."
  default     = false
}

variable "volume_type" {
  type        = string
  description = "(Optional) The type of volume. Can be 'standard', 'gp2', 'io1', 'sc1', or 'st1'. (Default: 'gp2')."
  default     = "gp2"
}

variable "volume_size" {
  type        = number
  description = "(Optional) The size of the volume in gibibytes (Default 10 GiB)."
  default     = 10
}
