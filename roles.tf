resource "snowflake_grant_privileges_to_account_role" "execute_task_grant" {
  provider          = snowflake.securityadmin
  privileges        = ["EXECUTE TASK"]
  account_role_name = "SYSADMIN"
  on_account        = true
}


#########################
## Project based Roles ##
#########################

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

## Delivery bases access roles
resource "snowflake_account_role" "ar_db_dds_read" {
  provider = snowflake.securityadmin
  for_each = { for db in local.all_delivery_databases : db.name => db }
  name     = "AR_DB_CURATED_${each.key}_R"
}

resource "snowflake_account_role" "ar_db_dds_write" {
  provider = snowflake.securityadmin
  for_each = { for db in local.all_delivery_databases : db.name => db }
  name     = "AR_DB_CURATED_${each.key}_W"
}

resource "snowflake_account_role" "dev_ar_db_dds_read" {
  provider = snowflake.securityadmin
  for_each = { for db in local.all_delivery_databases : db.name => db }
  name     = "DEV_AR_DB_CURATED_${each.key}_R"
}

resource "snowflake_account_role" "dev_ar_db_dds_write" {
  provider = snowflake.securityadmin

  for_each = { for db in local.all_delivery_databases : db.name => db }
  name     = "DEV_AR_DB_CURATED_${each.key}_W"
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
  for_each = { for db in local.all_source_databases : db.name => db }
  name     = "LOADER_${each.value.name}"
  comment  = "role for dataloaders"
}
