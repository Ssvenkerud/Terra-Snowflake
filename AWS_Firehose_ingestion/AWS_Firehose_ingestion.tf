####################################
## Firehose source data Ingedtion ##
####################################

terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = ">= 0.99.0"
      configuration_aliases = [
        snowflake.sysadmin,
        snowflake.useradmin,
        snowflake.securityadmin,
        snowflake.accountadmin
      ]
    }
  }
}


locals {
  firehose_ingestion_tables = flatten([
    for database_key, database in var.snowflake_firehose_ingestion_tables : [
      for object_key, table in database : [
        for table_key in table : {
          database_key = database_key
          refresh_key  = object_key
          table        = table_key
      }]
    ]
  ])
}


resource "snowflake_database" "prod_firehose_source_database" {
  provider                    = snowflake.sysadmin
  for_each                    = { for db in var.snowflake_firehose_ingestion_databases : db.database => db }
  name                        = "SOURCE_${each.value.database}"
  comment                     = "Soucrce data base fed by AWS Firehouse for ingestion"
  data_retention_time_in_days = each.value.retention_days
}

resource "snowflake_schema" "aws_firehose_landing_schema" {
  provider     = snowflake.sysadmin
  for_each     = { for db in var.snowflake_firehose_ingestion_databases : db.database => db }
  name         = "LANDING"
  database     = "SOURCE_${each.value.database}"
  comment      = "Schema containin the landing zone for data ingested via firehose for the source: ${each.value.database}"
  is_transient = false
  depends_on = [
    snowflake_database.prod_firehose_source_database,
  ]
}
resource "snowflake_schema" "aws_firehose_confomrmed_schema" {
  provider     = snowflake.sysadmin
  for_each     = { for db in var.snowflake_firehose_ingestion_databases : db.database => db }
  name         = "STAGING"
  database     = "SOURCE_${each.value.database}"
  comment      = "Schema containin the landing zone for data ingested via firehose for the source: ${each.value.database}"
  is_transient = false
  depends_on = [
    snowflake_database.prod_firehose_source_database,
  ]
}
resource "snowflake_table" "aws_firehose_landing_table" {
  provider        = snowflake.sysadmin
  for_each        = { for db in var.snowflake_firehose_ingestion_databases : db.database => db }
  change_tracking = true
  database        = "SOURCE_${each.value.database}"
  schema          = "LANDING"
  name            = "FIREHOSE"
  column {
    name     = "content"
    type     = "VARIANT"
    nullable = true
  }
  column {
    name     = "metadata"
    type     = "VARIANT"
    nullable = true
  }
  depends_on = [
    snowflake_database.prod_firehose_source_database,
    snowflake_schema.aws_firehose_landing_schema,
  ]
}

resource "snowflake_dynamic_table" "Firehose_conformed_tables" {
  provider     = snowflake.sysadmin
  for_each     = { for sp in local.firehose_ingestion_tables : join("_", [sp.database_key, sp.table]) => sp }
  refresh_mode = "AUTO"
  name         = upper(each.value.table)
  database     = "SOURCE_${each.value.database_key}"
  schema       = "LANDING"
  target_lag {
    maximum_duration = each.value.refresh_key
  }
  warehouse = var.snowflake_firehose_user.warehouse
  query     = "SELECT \"content\" FROM SOURCE_${each.value.database_key}.LANDING.FIREHOSE WHERE (\"content\":metadata:\"table-name\" =  '${each.value.table}')"
  comment   = "Automatic conformation of tables ingested by Firehose."

  depends_on = [
    snowflake_database.prod_firehose_source_database,
    snowflake_schema.aws_firehose_confomrmed_schema,
  ]
}

resource "snowflake_account_role" "ar_db_source_read" {
  provider = snowflake.securityadmin
  for_each = { for db in var.snowflake_firehose_ingestion_databases : db.database => db }

  name = "AR_DB_SOURCE_${each.key}_R"
}

resource "snowflake_account_role" "ar_db_source_write" {
  provider = snowflake.securityadmin
  for_each = { for db in var.snowflake_firehose_ingestion_databases : db.database => db }

  name = "AR_DB_SOURCE_${each.key}_W"

}

resource "snowflake_account_role" "loader_role" {
  provider = snowflake.securityadmin
  name     = "LOADER_${var.snowflake_firehose_user.name}"
  comment  = "Role used for the loading of data via AWS Firehouse user ${var.snowflake_firehose_user.name}"
}


resource "snowflake_service_user" "sys_aws_firehouse_loader" {
  provider                       = snowflake.useradmin
  name                           = "SYS_LOADER_${var.snowflake_firehose_user.name}"
  login_name                     = "SYS_LOADER_${var.snowflake_firehose_user.name}"
  comment                        = "system user for loading data using AWS Firehose"
  default_warehouse              = "LOADING_DATA_${var.snowflake_firehose_user.warehouse}"
  default_role                   = "LOADER_${var.snowflake_firehose_user.name}"
  default_secondary_roles_option = "NONE"
  rsa_public_key                 = var.aws_firehose_public_key1
  rsa_public_key_2               = var.aws_firehose_public_key2
}



