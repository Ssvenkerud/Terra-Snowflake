resource "snowflake_task" "Clone_prod_source" {
  for_each = var.snowflake_prod_source_databases
  comment = "Clone dev data from prod databases"

  database  = "database"
  schema    = "schema"
  warehouse = "warehouse"

  name          = "task"
  schedule      = "10 MINUTE"
  sql_statement = "select * from foo;"

  session_parameters = {
    "foo" : "bar",
  }

  user_task_timeout_ms = 10000
  after                = "preceding_task"
  when                 = "foo AND bar"
  enabled              = true
}
