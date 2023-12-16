resource snowflake_role loader_role {
    provider = useradmin
    for_each = var.data_loader
    name = "LOADER_{each.key}"
    comment = "role for dataloaders"
}

resource snowflake_role transformer_role {
    provider = useradmin
    name = "TRANSFORMER_{var.project_name}"
    comment = "role for the sytem user for production transformation"
}

resource snowflake_role data_engineer {
    provider = useradmin
    count = var.SSO_integration ? 1:0
    name = "DATA_ENGINEER_{var.project_name}"
}

resource snowflake_role data_analyst {
    provider = useradmin
    count = var.SSO_integration ? 1:0
    name = "DATA_ANALYST_{var.project_name}"
}


