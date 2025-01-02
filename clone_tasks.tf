resource "snowflake_task" "Source_clone" {
  provider  = snowflake.sysadmin
  for_each  = { for db in var.snowflake_prod_source_databases : db.name => db }
  database  = "SYSTEM"
  schema    = "dev_clones"
  name      = "Clone ${each.value.name} to prod"
  warehouse = snowflake_warehouse.sys_warehouse.fully_qualified_name
  started   = true
  schedule {
    minutes = 5
  }
  sql_statement = "CREATE OR REPLACE DATABASE DEV_SOURCE_${each.value.name} CLONE ${snowflake_database.prod_source_database[each.key].name};"
  depends_on = [
    snowflake_warehouse.sys_warehouse,
    snowflake_database.prod_source_database
  ]

}
