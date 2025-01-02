resource "snowflake_task" "Clone_prod_source" {
  provider = snowflake.sysadmin
  for_each = { for db in var.snowflake_prod_source_databases : db.name => db }


  comment = "Clone dev data from prod databases"

  started = true

  database  = snowflake_database.prod_source_database[each.key].name
  schema    = "PUBLIC"
  warehouse = snowflake_warehouse.sys_warehouse.id

  name = "Clone ${each.value.name} to Dev enviroment"
  schedule {
    minutes = 5
  }
  sql_statement = "CREATE OR REPLACE DATABASE DEV_SOURCE_${each.value.name} CLONE ${snowflake_database.prod_source_database[each.key].name};"
  depends_on    = [snowflake_warehouse.sys_warehouse]
}
