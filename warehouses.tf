resources snowflake_warehouse loading_warehouse {
    provider = sysadmin
    for_each = var.data_loaders
    name = "LOADING_DATA_{each.key}"
    size = each.value
}

resource snowflake_warehouse prod_transformer {
    provider = sysadmin
    name = "TRANSFORMER_{var.project_name}"
    size = var.prod_transformer_size
}

resource snowflake_warehouse dev_transformer {
    provider = sysadmin
    name = "DEV_TRANSFORMER_{var.project_name}"
    size = var.dev_transformer_size
}
