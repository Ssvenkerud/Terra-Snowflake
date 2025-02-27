resource "snowflake_database" "default_database" {
  provider                    = snowflake.sysadmin
  name                        = "CURATED_${var.project_name}"
  comment                     = "The database containing project dataproducts"
  data_retention_time_in_days = var.default_dds_retention_time
}
resource "snowflake_database" "dev_default_database" {
  provider                    = snowflake.sysadmin
  name                        = "DEV_CURATED_${var.project_name}"
  comment                     = "The database containing project dataproducts"
  data_retention_time_in_days = var.default_dds_retention_time
}
## DDS project

resource "snowflake_account_role" "ar_db_dds_project_read" {
  provider = snowflake.securityadmin
  name     = "AR_DB_CURATED_${var.project_name}_R"
}

resource "snowflake_account_role" "ar_db_dds_project_write" {
  provider = snowflake.securityadmin
  name     = "AR_DB_CURATED_${var.project_name}_W"
}

resource "snowflake_account_role" "dev_ar_db_dds_project_read" {
  provider = snowflake.securityadmin
  name     = "DEV_AR_DB_CURATED_${var.project_name}_R"
}

resource "snowflake_account_role" "dev_ar_db_dds_project_write" {
  provider = snowflake.securityadmin

  name = "DEV_AR_DB_CURATED_${var.project_name}_W"
}


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
resource "snowflake_account_role" "non_sso_data_domain_analyst" {
  provider = snowflake.securityadmin
  count    = var.snowflake_sso_integration ? 0 : 1
  name     = "DATA_ANALYST_${var.project_name}"
}
resource "snowflake_account_role" "non_sso_data_domain_scientist" {
  provider = snowflake.securityadmin
  count    = var.snowflake_sso_integration ? 0 : 1
  name     = "DATA_SCIENTIST_${var.project_name}"
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
