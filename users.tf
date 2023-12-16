resource snowflake_user sys_loader {
    provider = useradmin
    for_each = var.data_loader
    name = "SYS_LOADER_{each.key}"
    login_name = "SYS_LOADER_{each.key}"
    password = ""
    must_change_password = false
    comment = "system user for data loading"
}

resource snowflake_user sys_dbt_user {
    provider = useradmin
    name = "SYS_DBT_{var.project_name}"
    login_name = "SYS_DBT_{var.project_name}"
    password = ""
    Must_change_password = false
    comment = "DBT system user"
}
