resource "snowflake_task" "Clone_prod_source" {
for_each = { for db in var.snowflake_prod_source_databases : db.name => db} 

  comment = "Clone dev data from prod databases"

  database  = snowflake_database.prod_source_database[each.key].name
  schema    = "PUBLIC"
  warehouse = snowflake_warehouse.sys_warehouse.id

  name          = "Clone ${each.value.name} to Dev enviroment"
  schedule      = "10 MINUTE"
  sql_statement = "CREATE OR REPLACE DATABASE target CLONE source;"

  session_parameters = {
    "source" : "${snowflake_database.prod_source_database[each.key].name}",
    "target" : "DEV_SOURCE${each.value.name}"
  }

  user_task_timeout_ms = 10000
  after                = "preceding_task"
  when                 = "foo AND bar"
  enabled              = true
}
