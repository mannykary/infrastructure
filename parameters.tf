resource "aws_ssm_parameter" "db_host" {
  name = "/fp/database/host"
  type = "String"
  value = aws_docdb_cluster.main.endpoint
}

resource "aws_ssm_parameter" "db_user" {
  name = "/fp/database/user"
  type = "String"
  value = aws_docdb_cluster.main.master_username
}

resource "aws_ssm_parameter" "db_password" {
  name = "/fp/database/password"
  type = "SecureString"
  value = random_password.db.result
}

resource "aws_ssm_parameter" "domain" {
  name = "/fp/domain"
  type = "String"
  value = var.domain
}