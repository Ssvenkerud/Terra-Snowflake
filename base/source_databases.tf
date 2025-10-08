
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
resource "snowflake_schema" "landing_schema" {
  provider     = snowflake.sysadmin
  for_each     = { for db in var.snowflake_prod_source_databases : db.name => db }
  name         = "LANDING"
  database     = "SOURCE_${each.value.name}"
  comment      = "Schema containin the landing zone for data ingested via external stage for the source: ${each.value.name}"
  is_transient = false
  depends_on = [
    snowflake_database.prod_only_source_database,
  ]
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
