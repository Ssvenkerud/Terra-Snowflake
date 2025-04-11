####################################
## Firehose source data Ingedtion ##
####################################



variable "snowflake_firehose_ingestion_tables" {
  type = map(map(list(string)))
  default = {
    test_db = {
      "Tables" = ["test_tbl", "tbl_two"]
    }
    test_db2 = {
      "Tables" = ["test_tbl", "tbl_two"]
    }
  }
}

variable "snowflake_firehose_ingestion_databases" {
  type = list(object({}))
  default = {
    database       = string
    retention_days = string
  }
}

variable "snowflake_firehose_user" {
  description = "Settings for warehouse that are used for the data ingestion process. "
  type = object({
    name      = string
    warehouse = string
  })
}

variable "aws_firehose_public_key1" {
  description = "Primary public key for authentication to Snowflake, Must be on 1 line without header and trailer"
  type        = string
  sensitive   = true
}

variable "aws_firehose_public_key2" {
  description = "Secondary public key for authentication to Snowflake, Must be on 1 line without header and trailer"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "The name of the project that is the holder of the terraform state."
  default     = "my-project"
}

locals {
  firehose_ingestion_tables = flatten([
    for database_key, database in var.snowflake_firehose_ingestion_tables : [
      for object_key, table in database : {
        database_key = database_key
        object_key   = object_type_key
        table        = table
      }
    ]
  ])
}


resource "snowflake_database" "prod_firehose_source_database" {
  provider                    = snowflake.sysadmin
  for_each                    = { for db in var.snowflake_firehose_ingestion_databases : db.database => db }
  name                        = "SOURCE_${each.value.database}"
  comment                     = "Soucrce data base fed by AWS Firehouse for ingestion"
  data_retention_time_in_days = each.value.data_retention_days
}

resource "snowflake_schema" "aws_firehose_landing_schema" {
  provider     = snowflake.sysadmin
  for_each     = { for db in var.snowflake_firehose_ingestion_databases : db.database => db }
  name         = "LANDING"
  database     = "SOURCE_${each.value.database}"
  comment      = "Schema cont ainin the landing zone for data ingested via firehose for the source: ${each.value.name}"
  is_transient = true
}

resource "snowflake_table" "aws_firehose_landing_tables" {
  provider = snowflake.sysadmin
  for_each = { for index, sp in local.firehose_ingestion_tables : index => sp }
  database = "SOURCE_${each.value.database_key}"
  schema   = "LANDING"
  name     = each.value.table
  column {
    name     = "data"
    type     = "VARIANT"
    nullable = true
  }
  column {
    name     = "metadata"
    type     = "VARIANT"
    nullable = true
  }
}

resource "snowflake_database_role" "ar_db_source_read" {
  provider = snowflake.securityadmin
  for_each = { for db in var.snowflake_firehose_ingestion_databases : db.name => db }

  database   = snowflake_database.prod_firehose_source_database[each.key].fully_qualified_name
  name       = "AR_DB_SOURCE_${each.key}_R"
  depends_on = [snowflake_database.prod_firehose_source_database]
}

resource "snowflake_database_role" "ar_db_source_write" {
  provider = snowflake.securityadmin
  for_each = { for db in var.snowflake_firehose_ingestion_databases : db.name => db }

  database   = snowflake_database.prod_firehose_source_database[each.key].fully_qualified_name
  name       = "AR_DB_SOURCE_${each.key}_W"
  depends_on = [snowflake_database.prod_firehose_source_database]

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


resource "snowflake_task" "clone_source_to_dev" {
  provider  = snowflake.sysadmin
  for_each  = { for db in var.snowflake_firehose_ingestion_databases : db.name => db }
  database  = "SYSTEM"
  schema    = "DEV_CLONES"
  name      = "Clone_${each.value.name}_to_prod"
  warehouse = "SYSTEM_${var.project_name}"
  started   = true
  schedule {
    using_cron = each.value.clone_frequency_cron
  }
  sql_statement = "CREATE OR REPLACE DATABASE DEV_SOURCE_${each.value.name} CLONE SOURCE_${each.value.name}"
  depends_on = [
    snowflake_database.prod_firehose_source_database
  ]

}
