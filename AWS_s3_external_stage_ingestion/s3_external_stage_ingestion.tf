terraform {
  required_providers {
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = ">= 2.7.0"
      configuration_aliases = [
        snowflake.sysadmin,
        snowflake.useradmin,
        snowflake.securityadmin,
        snowflake.accountadmin
      ]
    }
  }
}



resource "snowflake_stage" "S3_ingestion_stage" {
  provider            = snowflake.accountadmin
  for_each            = { for db in var.snowflake_s3_sources : db.source => db }
  name                = "SOURCE_STAGE_${each.value.source}"
  url                 = each.value.s3_location
  database            = "SOURCE_${each.value.source}"
  schema              = "LANDING"
  storage_integration = "S3_STORAGE"
  directory           = "ENABLE = true"

}


