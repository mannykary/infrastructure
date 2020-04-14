resource "random_password" "db" {
  length = 16
  special = false
  number = false
}

resource "aws_docdb_cluster" "main" {
  cluster_identifier = "${var.fp_context}-db"
  engine = "docdb"
  master_username = "fp_admin"
  master_password = random_password.db.result
  backup_retention_period = 5
  skip_final_snapshot = true
  apply_immediately = true
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name = module.vpc.database_subnet_group
  storage_encrypted = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  cluster_identifier = aws_docdb_cluster.main.id
  instance_class = "db.r4.large"
  identifier = "${var.fp_context}-db-instance-${count.index + 1}"
  count = 1
}