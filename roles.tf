#########################
## Project based Roles ##
#########################

resource "snowflake_account_role" "non_sso_data_engineer" {
  provider = snowflake.useradmin
  count    = var.snowflake_sso_integration ? 0 : 1
  name     = "DATA_ENGINEER_${var.project_name}"
}

resource "snowflake_account_role" "non_sso_data_analyst" {
  provider = snowflake.useradmin
  count    = var.snowflake_sso_integration ? 0 : 1
  name     = "DATA_READER_${var.project_name}"
}

resource "snowflake_account_role" "non_sso_data_domain_admin" {
  provider = snowflake.useradmin
  count    = var.snowflake_sso_integration ? 0 : 1
  name     = "DATA_${var.project_name}_ADMIN"
}

resource "snowflake_account_role" "Powerbi_role" {
  provider = snowflake.useradmin
  count    = var.snowflake_powerbi_enabled ? 1 : 0
  name     = "POWERBI_${var.project_name}"
}

resource "snowflake_account_role" "transformer_role" {
  provider = snowflake.useradmin
  name     = "TRANSFORMER_${var.project_name}"
  comment  = "role for the sytem user for production transformation"
}

resource "snowflake_account_role" "extra_roles" {
  provider = snowflake.useradmin
  for_each = toset(var.snowflake_additional_roles)
  name     = each.key
}

#############################
## AR roles for databases ##
#############################

locals {
  all_prod_databases = concat(var.snowflake_delivery_databases, var.snowflake_prod_source_databases)
  all_dev_databases  = concat(var.snowflake_delivery_databases, var.snowflake_dev_source_databases)

}

resource "snowflake_account_role" "ar_db_read" {
  provider = snowflake.useradmin
  for_each = { for db in local.all_prod_databases : db.name => db }
  name     = "ar_db_${each.key}_R"
}

resource "snowflake_account_role" "ar_db_write" {
  provider = snowflake.useradmin
  for_each = { for db in local.all_prod_databases : db.name => db }
  name     = "ar_db_${each.key}_W"
}

resource "snowflake_account_role" "dev_ar_db_read" {
  provider = snowflake.useradmin
  for_each = { for db in local.all_dev_databases : db.name => db }
  name     = "dev_ar_db_${each.key}_R"
}

resource "snowflake_account_role" "dev_ar_db_write" {
  provider = snowflake.useradmin
  for_each = { for db in local.all_dev_databases : db.name => db }
  name     = "dev_ar_db_${each.key}_W"
}

resource "snowflake_account_role" "ar_schema_read" {
  provider = snowflake.useradmin
  for_each = { for role in var.snowflake_schema_role_read : role.name => role }
  name     = "ar_schema_${each.value.name}_R"
}

#############################
## System Functional Roles ##
#############################


resource "snowflake_account_role" "loader_role" {
  provider = snowflake.useradmin
  for_each = { for db in var.snowflake_prod_source_databases : db.name => db }
  name     = "loader_${each.value.name}"
  comment  = "role for dataloaders"
}
