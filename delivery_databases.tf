
resource "snowflake_database" "delivery_database" {
  provider                    = snowflake.sysadmin
  for_each                    = { for db in var.snowflake_delivery_databases : db.name => db }
  name                        = "CURATED_${each.value.name}"
  comment                     = "delivery database"
  data_retention_time_in_days = each.value.data_retention_days
}
