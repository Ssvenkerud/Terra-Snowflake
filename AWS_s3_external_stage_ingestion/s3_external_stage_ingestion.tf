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

resource "snowflake_grant_privileges_to_account_role" "snowflake_external_stage_usage_all" {
  provider          = snowflake.accountadmin
  for_each          = { for db in var.snowflake_s3_sources : db.source => db }
  privileges        = ["USAGE"]
  account_role_name = "AR_DB_SOURCE_${each.value.source}_R"

  on_schema_object {
    all {
      object_type_plural = "STAGE"
      in_schema          = "SOURCE_${each.value.source}.LANDING"
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "snowflake_external_stage_usage_future" {
  provider          = snowflake.accountadmin
  for_each          = { for db in var.snowflake_s3_sources : db.source => db }
  privileges        = ["USAGE"]
  account_role_name = "AR_DB_SOURCE_${each.value.source}_R"

  on_schema_object {
    future {
      object_type_plural = "STAGE"
      in_schema          = "SOURCE_${each.value.source}.LANDING"
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "snowflake_external_stage_select_all" {
  provider          = snowflake.accountadmin
  for_each          = { for db in var.snowflake_s3_sources : db.source => db }
  privileges        = ["SELECT"]
  account_role_name = "AR_DB_SOURCE_${each.value.source}_R"

  on_schema_object {
    all {
      object_type_plural = "EXTERNAL TABLE"
      in_schema          = "SOURCE_${each.value.source}.LANDING"
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "snowflake_external_stage_select_future" {
  provider          = snowflake.accountadmin
  for_each          = { for db in var.snowflake_s3_sources : db.source => db }
  privileges        = ["SELECT"]
  account_role_name = "AR_DB_SOURCE_${each.value.source}_R"

  on_schema_object {
    future {
      object_type_plural = "EXTERNAL TABLE"
      in_schema          = "SOURCE_${each.value.source}.LANDING"
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "snowflake_external_stage_create" {
  provider          = snowflake.accountadmin
  for_each          = { for db in var.snowflake_s3_sources : db.source => db }
  privileges        = ["CREATE"]
  account_role_name = "AR_DB_SOURCE_${each.value.source}_W"

  on_schema {
    schema_name = "SOURCE_${each.value.source}.LANDING"
  }
}
