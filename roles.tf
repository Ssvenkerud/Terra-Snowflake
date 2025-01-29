#########################
## Project based Roles ##
#########################

resource "snowflake_account_role" "non_sso_data_engineer" {
  provider = snowflake.securityadmin
  count    = var.snowflake_sso_integration ? 0 : 1
  name     = "DATA_ENGINEER_${var.project_name}"
}

resource "snowflake_account_role" "non_sso_data_analyst" {
  provider = snowflake.securityadmin
  count    = var.snowflake_sso_integration ? 0 : 1
  name     = "DATA_READER_${var.project_name}"
}

resource "snowflake_account_role" "non_sso_data_domain_admin" {
  provider = snowflake.securityadmin
  count    = var.snowflake_sso_integration ? 0 : 1
  name     = "DATA_ADMIN_${var.project_name}"
}

resource "snowflake_account_role" "Powerbi_role" {
  provider = snowflake.securityadmin
  count    = var.snowflake_powerbi_enabled ? 1 : 0
  name     = "POWERBI_${var.project_name}"
}

resource "snowflake_account_role" "transformer_role" {
  provider = snowflake.securityadmin
  name     = "TRANSFORMER_${var.project_name}"
  comment  = "role for the sytem user for production transformation"
}

resource "snowflake_account_role" "extra_roles" {
  provider = snowflake.securityadmin
  for_each = toset(var.snowflake_additional_roles)
  name     = each.key
}

#############################
## AR roles for databases ##
#############################


locals {
  all_delivery_databases = concat(var.snowflake_delivery_databases)
  all_source_databases   = concat(var.snowflake_prod_source_databases, var.snowflake_dev_source_databases)

}
## DDS project

resource "snowflake_account_role" "ar_db_dds_project_read" {
  provider = snowflake.securityadmin
  name     = "AR_DB_DDS_${var.project_name}_R"
}

resource "snowflake_account_role" "ar_db_dds_project_write" {
  provider = snowflake.securityadmin
  name     = "AR_DB_DDS_${var.project_name}_W"
}

resource "snowflake_account_role" "dev_ar_db_dds_project_read" {
  provider = snowflake.securityadmin
  name     = "DEV_AR_DB_DDS_${var.project_name}_R"
}

resource "snowflake_account_role" "dev_ar_db_dds_project_write" {
  provider = snowflake.securityadmin

  name = "DEV_AR_DB_DDS_${var.project_name}_W"
}
## DDS bases
resource "snowflake_account_role" "ar_db_dds_read" {
  provider = snowflake.securityadmin
  for_each = { for db in local.all_delivery_databases : db.name => db }
  name     = "AR_DB_DDS_${each.key}_R"
}

resource "snowflake_account_role" "ar_db_dds_write" {
  provider = snowflake.securityadmin
  for_each = { for db in local.all_delivery_databases : db.name => db }
  name     = "AR_DB_DDS_${each.key}_W"
}

resource "snowflake_account_role" "dev_ar_db_dds_read" {
  provider = snowflake.securityadmin
  for_each = { for db in local.all_delivery_databases : db.name => db }
  name     = "DEV_AR_DB_DDS_${each.key}_R"
}

resource "snowflake_account_role" "dev_ar_db_dds_write" {
  provider = snowflake.securityadmin

  for_each = { for db in local.all_delivery_databases : db.name => db }
  name     = "DEV_AR_DB_DDS_${each.key}_W"
}

## Source databases
resource "snowflake_account_role" "ar_db_source_read" {
  provider = snowflake.securityadmin

  for_each = { for db in local.all_source_databases : db.name => db }
  name     = "AR_DB_SOURCE_${each.key}_R"
}

resource "snowflake_account_role" "ar_db_source_write" {
  provider = snowflake.securityadmin
  for_each = { for db in local.all_source_databases : db.name => db }
  name     = "AR_DB_SOURCE_${each.key}_W"
}

resource "snowflake_account_role" "dev_ar_db_source_read" {
  provider = snowflake.securityadmin
  for_each = { for db in local.all_source_databases : db.name => db }
  name     = "DEV_AR_DB_SOURCE_${each.key}_R"
}

resource "snowflake_account_role" "dev_ar_db_source_write" {
  provider = snowflake.securityadmin
  for_each = { for db in local.all_source_databases : db.name => db }
  name     = "DEV_AR_DB_SOURCE_${each.key}_W"
}

resource "snowflake_account_role" "ar_schema_read" {
  provider = snowflake.securityadmin
  for_each = { for role in var.snowflake_schema_role_read : role.name => role }
  name     = "AR_SCHEMA_${each.value.name}_R"
}

#############################
## System Functional Roles ##
#############################


resource "snowflake_account_role" "loader_role" {
  provider = snowflake.securityadmin
  for_each = { for db in var.snowflake_prod_source_databases : db.name => db }
  name     = "LOADER_${each.value.name}"
  comment  = "role for dataloaders"
}
