resource snowflake_service_user sys_loader {
    provider = snowflake.useradmin
    for_each ={ for user in var.snowflake_data_loader : user.source => user }
    name = "SYS_LOADER_${each.value.source}"
    login_name = "SYS_LOADER_${each.value.source}"
    password = ""
    must_change_password = false
    comment = "system user for data loading"
    default_warehouse ="LOADING_DATA_${each.value.source}"
    default_role = "LOADER_${each.value.source}"
    #abort_detached_query = true
    #client_session_keep_alive = false
    #disable_mfa = true
    #query_tag = "DATA_LOADER"
}

resource snowflake_service_user sys_dbt_user {
    provider = snowflake.useradmin
    count = var.snowflake_dbt_enabled ? 1 : 0
    name = "SYS_DBT_${var.project_name}"
    login_name = "SYS_DBT_${var.project_name}"
    password = ""
    must_change_password = false
    comment = "system user for data loading"
    #abort_detached_query = true
    #client_session_keep_alive = false
    #disable_mfa = true
    #query_tag = "DATA_LOADER"
}
resource snowflake_service_user sys_powerbi_user {
    provider = snowflake.useradmin
    count = var.snowflake_powerbi_enabled ? 1 : 0
    name = "SYS_POWERBI_${var.project_name}"
    login_name = "SYS_POWERBI_${var.project_name}"
    password = ""
    must_change_password = false
    comment = "system user for data loading"
    #abort_detached_query = true
    #client_session_keep_alive = false
    #disable_mfa = true
    #query_tag = "DATA_LOADER"
}

resource snowflake_service_user sys_permifrost_user {
    provider = snowflake.useradmin
    count = var.snowflake_permifrost_enabled ? 1 : 0
    name = "SYS_PERMIFROST"
    login_name = "SYS_PERMIFROST"
    password = ""
    must_change_password = false
    comment = "system user for data loading"
    default_role = "SECURITYADMIN"
    #abort_detached_query = true
    #client_session_keep_alive = false
    #disable_mfa = true
    #query_tag = "DATA_LOADER"
}
