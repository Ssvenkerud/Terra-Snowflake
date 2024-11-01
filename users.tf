resource snowflake_user sys_loader {
    provider = useradmin
    for_each = var.snowflake_data_loader
    name = "SYS_LOADER_${each.key}"
    login_name = "SYS_LOADER_${each.key}"
    password = ""
    must_change_password = false
    comment = "system user for data loading"
}

resource snowflake_user sys_dbt_user {
    provider = useradmin
    count = var.snowflake_dbt_enabled ? 1 : 0
    name = "SYS_DBT_${var.project_name}"
    login_name = "SYS_DBT_${var.project_name}"
    password = ""
    Must_change_password = false
    comment = "DBT system user"
}


resource snowflake_user sys_prefect_user {
    provider = useradmin
    count = var.snowflake_prefect_enabled ? 1 : 0
    name = "SYS_PREFECT_${var.project_name}"
    login_name = "SYS_PREFECT_${var.project_name}"
    password = ""
    Must_change_password = false
    comment = "Prefect system user"
 }


resource snowflake_user sys_powerbi_user {
    provider = useradmin
    count = var.snowflake_powerbi_enabled ? 1 : 0
    name = "SYS_POWERBI_${var.project_name}"
    login_name = "SYS_POWERBI_${var.project_name}"
    password = ""
    Must_change_password = false
    comment = "Prefect system user"
 }
