resource snowflake_database "default_database" {
    provider = sysadmin
    name = "DDS_{var.project_name}"
    comment = "The database containing project dataproducts"
    data_retention_time_in_days = var.default_retention_time
    }

resource snowlake_database prod_source_database{
    provider = sysadmin
    for_each = var.prod_source_databases
    name = "LANDING_{each.key}"
    comment = "Production source database"
    data_retention_time_in_days = {each.value}
    }

resource snowflake_database dev_source_database {
    provider = sysadmin
    for_each = var.dev_source_databases
    name = "LANDING_{each.key}"
    comment = "Dev source database"
    data_retention_time_in_days = {each.value}
    }

resource snowflake_database rd_layer_database {
    provider = sysadmin
    for_each = concatenate(var.dev_source_databases, var.prod_source_databases)
    name = "LANDING_{each.key}"
    comment = "Database for storing RD layer Views, transient without
    timetravel"
    }

resource snowflake_database delivery_database {
    provider = sysadmin
    for_each = var.delivery_databases
    name = "DDS_{each.key}"
    comment = "delivery database"
    data_retention_time_in_days = {each.value}
    }

resource snowflake_database export_database {
    provider = sysadmin
    for_each = var.export_databases
    name = "EXPORT_{each.key}"
    comment = "Database for the export and sharing of dataproducts"
    data_retention_time_in_days = {each.value}
    }
