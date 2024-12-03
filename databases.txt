resource "snowflake_database" "default_database" {
    provider = snowflake.sysadmin
    name = "DDS_{var.project_name}"
    comment = "The database containing project dataproducts"
    data_retention_time_in_days = var.default_retention_time
    }

resource "snowlake_database" "prod_source_database"{
    provider = snowflake.sysadmin
    for_each = var.snowflake_prod_source_databases
    name = "LANDING_${each.value.source}"
    comment = "Production source database"
    data_retention_time_in_days = each.value.data_retention_days
    }

resource "snowlake_database" "dev_source_database"{
    provider = snowflake.sysadmin
    for_each = var.snowflake_dev_source_databases
    name = "DEV_LANDING_${each.value.source}"
    comment = "development source database"
    data_retention_time_in_days = each.value.data_retention_days
    }

resource "snowflake_database" "rd_layer_database" {
    provider = snowflake.sysadmin
    for_each = concatenate(var.snowflake_dev_source_databases, var.snowflake_prod_source_databases)
    name = "RD_${each.key}"
    comment = "Database for storing RD layer Views, transient without timetravel"
    }

resource "snowflake_database" "delivery_database" {
    provider = snowflake.sysadmin
    for_each = var.snowflake_delivery_databases
    name = "DDS_${each.value.name}"
    comment = "delivery database"
    data_retention_time_in_days = each.value.data_retention_days
    }

resource "snowflake_database" "export_database" {
    provider = snowflake.sysadmin
    for_each = var.snowflake_export_databases
    name = "EXPORT_${each.key}"
    comment = "Database for the export and sharing of dataproducts"
    data_retention_time_in_days = each.value.data_retention_days
    }
