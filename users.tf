resource "snowflake_service_user" "sys_loader" {
  provider          = snowflake.useradmin
  for_each          = { for user in var.snowflake_data_loader : user.source => user }
  name              = "SYS_LOADER_${each.value.source}"
  login_name        = "SYS_LOADER_${each.value.source}"
  comment           = "system user for data loading"
  default_warehouse = "LOADING_DATA_${each.value.source}"
  default_role      = "LOADER_${each.value.source}"
  #abort_detached_query = true
  #client_session_keep_alive = false
  #disable_mfa = true
  #query_tag = "DATA_LOADER"
}

resource "snowflake_service_user" "sys_dbt_user" {
  provider   = snowflake.useradmin
  count      = var.snowflake_dbt_enabled ? 1 : 0
  name       = "SYS_DBT_${var.project_name}"
  login_name = "SYS_DBT_${var.project_name}"
  comment    = "system user for data loading"
  #abort_detached_query = true
  #client_session_keep_alive = false
  #disable_mfa = true
  #query_tag = "DATA_LOADER"
}
resource "snowflake_service_user" "sys_powerbi_user" {
  provider   = snowflake.useradmin
  count      = var.snowflake_powerbi_enabled ? 1 : 0
  name       = "SYS_POWERBI_${var.project_name}"
  login_name = "SYS_POWERBI_${var.project_name}"
  comment    = "system user for data loading"
  #abort_detached_query = true
  #client_session_keep_alive = false
  #disable_mfa = true
  #query_tag = "DATA_LOADER"
}

resource "snowflake_service_user" "sys_permifrost_user" {
  provider          = snowflake.useradmin
  count             = var.snowflake_permifrost_enabled ? 1 : 0
  name              = "SYS_PERMIFROST"
  login_name        = "SYS_PERMIFROST"
  comment           = "system user for data loading"
  default_role      = "SECURITYADMIN"
  default_warehouse = "SYSTEM"
  rsa_public_key    = var.PERMIFROST_KEY
  #abort_detached_query = true
  #client_session_keep_alive = false
  #disable_mfa = true
  #query_tag = "DATA_LOADER"
}
resource "snowflake_grant_account_role" "Permifrost_grant" {
  provider = snowflake.securityadmin
  count    = var.snowflake_permifrost_enabled ? 1 : 0

  role_name = "SECURITYADMIN"
  user_name = snowflake_service_user.sys_permifrost_user[0].name
}

resource "snowflake_grant_privileges_to_role" "Permifrost_Warehouse" {
  provider   = snowflake.securityadmin
  privileges = ["USAGE"]
  role_name  = "SECURITYADMIN"
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = "SYSTEM"
  }
}
