################
# PgPool SSH Key
################
resource "aws_key_pair" "this" {
  key_name   = "${var.hostname}.${var.dns_zone}"
  public_key = var.public_ssh_key
}

#######################
# EC2 - PgPool Instance
#######################
resource "aws_instance" "this" {
  ami                         = var.ami
  associate_public_ip_address = false
  iam_instance_profile        = var.iam_instance_profile
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.this.key_name
  subnet_id                   = var.subnet_id
  tags                        = merge(var.tags, { Name = "${var.hostname}.${var.dns_zone}" })
  vpc_security_group_ids      = [aws_security_group.this.id, var.database_security_group]

  root_block_device {
    encrypted   = var.encrypted
    volume_type = var.volume_type
    volume_size = var.volume_size
  }
}

##################
# Route53 DNS Zone
##################
data "aws_route53_zone" "this" {
  count = var.use_external_dns == false ? 1 : 0

  name         = var.dns_zone
  private_zone = var.dns_private_zone
}

#############################
# Route53 A Record for PgPool
#############################
resource "aws_route53_record" "this" {
  count = var.use_external_dns == false ? 1 : 0

  zone_id = data.aws_route53_zone.this[0].zone_id
  name    = var.hostname
  type    = "A"
  ttl     = "300"
  records = var.dns_private_zone == true ? [aws_instance.this.private_ip] : [aws_instance.this.public_ip]
}

#############################
# Security Group - EC2 PgPool
#############################
resource "aws_security_group" "this" {
  description = "PgPool Node"
  vpc_id      = var.vpc_id
  name        = "${var.hostname}-${var.namespace}"
  tags        = merge(var.tags, { Name = "${var.hostname}-${var.namespace}" })

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = 6
    cidr_blocks = var.allow_cidr
    description = "Allow incoming SSH connections."
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = 6
    cidr_blocks = var.allow_cidr
    description = "Allow incoming Postgres connections."
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outgoing traffic."
  }
}

#####################################################
# Security Group Rule - Allow PgPool Database Access
#####################################################
resource "aws_security_group_rule" "database_acccess" {
  count = var.database_security_group == null ? 0 : length(var.database_ports)

  type                     = "ingress"
  from_port                = var.database_ports[count.index].port
  to_port                  = var.database_ports[count.index].port
  protocol                 = 6
  source_security_group_id = aws_security_group.this.id
  description              = var.database_ports[count.index].description
  security_group_id        = var.database_security_group
}
