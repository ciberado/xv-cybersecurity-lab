# Create an RDS parameter group to enable CloudWatch logging
resource "aws_db_parameter_group" "lab_db_parameter_group" {
  name        = "lab-db-parameter-group"
  family      = "mysql5.7"
  description = "Custom parameter group for RDS MySQL with CloudWatch logging"

  parameter {
    name  = "slow_query_log"
    value = "1"
  }
  #slow_query_log = 1 or log_slow_query = 1

  parameter {
    name  = "general_log"
    value = "1"
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }
}

#Create an option group to enable the MariaDB audit plugin
resource "aws_db_option_group" "lab_db_option_group" {
  name                     = "lab-db-option-group"
  engine_name              = "mysql"
#  major_engine_version     = "8.0"
  major_engine_version     = "5.7"

  option_group_description = "Option group for enabling MariaDB audit plugin"

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"
    option_settings {
      name  = "SERVER_AUDIT_EVENTS"
      value = "CONNECT,QUERY,QUERY_DDL,QUERY_DML,QUERY_DML_NO_SELECT,QUERY_DCL"
    }
  }
  tags = {
    Name = "lab_db_option_group"
  }
}



# RDS Instance creation
resource "aws_db_instance" "db_instance" {
  identifier                      = "labdatabase"
  allocated_storage               = var.database_settings.mysql.allocated_storage
  engine                          = var.database_settings.mysql.engine
  engine_version                  = var.database_settings.mysql.engine_version
  instance_class                  = var.database_settings.mysql.instance_class
  db_name                         = var.database_settings.mysql.db_name
  username                        = var.database_settings.mysql.username
  password                        = var.database_settings.mysql.password
  multi_az                        = var.database_settings.mysql.multi_az
  apply_immediately               = var.database_settings.mysql.apply_immediately
  skip_final_snapshot             = var.database_settings.mysql.skip_final_snapshot
  db_subnet_group_name            = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids          = [aws_security_group.database_sg.id]
  parameter_group_name            = aws_db_parameter_group.lab_db_parameter_group.name
  option_group_name               = aws_db_option_group.lab_db_option_group.name
  enabled_cloudwatch_logs_exports = ["slowquery", "error", "general", "audit"]
  tags = {
    Name = "Lab Database"
  }
}