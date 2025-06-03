
resource "snowflake_database" "prod_only_source_database" {
  provider                    = snowflake.sysadmin
  for_each                    = { for db in var.snowflake_prod_source_databases : db.name => db }
  name                        = "SOURCE_${each.value.name}"
  comment                     = "Production source database"
  data_retention_time_in_days = each.value.data_retention_days
  lifecycle {
    prevent_destroy = false
  }
}


resource "snowflake_database" "dev_source_database" {
  provider                    = snowflake.sysadmin
  for_each                    = { for db in var.snowflake_dev_source_databases : db.name => db }
  name                        = "DEV_SOURCE_${each.value.name}"
  comment                     = "development source database"
  data_retention_time_in_days = each.value.data_retention_days
}
resource "snowflake_database" "prod_source_database" {
  provider                    = snowflake.sysadmin
  for_each                    = { for db in var.snowflake_dev_source_databases : db.name => db }
  name                        = "SOURCE_${each.value.name}"
  comment                     = "production source database"
  data_retention_time_in_days = each.value.data_retention_days
}
