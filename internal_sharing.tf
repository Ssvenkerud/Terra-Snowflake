


resource "snowflake_database" "central_internal_shareing_database" {
  provider = snowflake.sysadmin
  count    = var.snowflake_central_internal_share_setup ? 1 : 0

  name                        = "INTERNAL_SHAREING"
  comment                     = "This database acts as as central sharing layer for data between the teams"
  data_retention_time_in_days = var.default_dds_retention_time
}

resource "snowflake_role" "central_internal_shareing_role_w" {
  provider = snowflake.sysadmin
  count    = var.snowflake_central_internal_share_setup ? 1 : 0


  name    = "AR_DB_INTERNAL_SHAREING_W"
  comment = "database write access role"
}

resource "snowflake_role" "central_internal_shareing_role_r" {
  provider = snowflake.sysadmin
  count    = var.snowflake_central_internal_share_setup ? 1 : 0


  name    = "AR_DB_INTERNAL_SHAREING_R"
  comment = "database read access role"
}

resource "snowflake_database" "project_internal_shareing_database" {
  provider = snowflake.sysadmin
  count    = var.snowflake_project_internal_share_setup ? 1 : 0

  name                        = "INTERNAL_SHAREING_${var.project_name}"
  comment                     = "This database acts as as central sharing layer for data between the teams"
  data_retention_time_in_days = var.default_dds_retention_time
}

resource "snowflake_role" "project_internal_shareing_role_w" {
  provider = snowflake.sysadmin
  count    = var.snowflake_project_internal_share_setup ? 1 : 0


  name    = "AR_DB_INTERNAL_SHAREING_${var.project_name}_W"
  comment = "database write access role"
}

resource "snowflake_role" "project_internal_shareing_role_r" {
  provider = snowflake.sysadmin
  count    = var.snowflake_project_internal_share_setup ? 1 : 0


  name    = "AR_DB_INTERNAL_SHAREING_${var.project_name}_R"
  comment = "database read access role"
}
