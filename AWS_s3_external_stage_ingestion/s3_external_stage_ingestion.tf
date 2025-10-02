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


resource "snowflake_database" "s3_source_database" {
  provider                    = snowflake.sysadmin
  for_each                    = { for db in var.snowflake_s3_sources : db.source => db }
  name                        = "SOURCE_${each.value.source}"
  comment                     = "Production source database"
  data_retention_time_in_days = each.value.data_retention_days
  lifecycle {
    prevent_destroy = false
  }
}



resource "snowflake_schema" "s3_landing_landing_schema" {
  provider     = snowflake.sysadmin
  for_each     = { for db in var.snowflake_s3_sources : db.source => db }
  name         = "LANDING"
  database     = "SOURCE_${each.value.source}"
  comment      = "Schema containin the landing zone for data ingested via external stage for the source: ${each.value.source}"
  is_transient = false
  depends_on = [
    snowflake_database.s3_source_database,
  ]
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


resource "snowflake_account_role" "ar_db_source_read" {
  provider = snowflake.securityadmin
  for_each = { for db in var.snowflake_s3_sources : db.source => db }

  name = "AR_DB_SOURCE_${each.key}_R"
}

resource "snowflake_account_role" "ar_db_source_write" {
  provider = snowflake.securityadmin
  for_each = { for db in var.snowflake_s3_sources : db.source => db }

  name = "AR_DB_SOURCE_${each.key}_W"

}

resource "snowflake_account_role" "dev_ar_db_source_read" {
  provider = snowflake.securityadmin
  for_each = { for db in var.snowflake_s3_sources : db.source => db }

  name = "DEV_AR_DB_SOURCE_${each.key}_R"
}

resource "snowflake_account_role" "dev_ar_db_source_write" {
  provider = snowflake.securityadmin
  for_each = { for db in var.snowflake_s3_sources : db.source => db }

  name = "DEV_AR_DB_SOURCE_${each.key}_W"

}


