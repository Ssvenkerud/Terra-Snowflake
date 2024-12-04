resource "snowflake_database" "default_database" {
    provider = snowflake.sysadmin
    name = "DDS_${var.project_name}"
    comment = "The database containing project dataproducts"
    data_retention_time_in_days = var.default_dds_retention_time
    }


resource "snowflake_database" "prod_source_database"{
    provider = snowflake.sysadmin
    for_each = var.snowflake_prod_source_databases
    name = "SOURCE_${each.value.source}"
    comment = "Production source database"
    data_retention_time_in_days = each.value.data_retention_days
    }

resource "snowflake_database" "dev_source_database"{
    provider = snowflake.sysadmin
    for_each = var.snowflake_dev_source_databases
    name = "DEV_SOURCE_${each.value.source}"
    comment = "development source database"
    data_retention_time_in_days = each.value.data_retention_days
    }

resource "snowflake_database" "delivery_database" {
    provider = snowflake.sysadmin
    for_each = var.snowflake_delivery_databases
    name = "DDS_${each.value.name}"
    comment = "delivery database"
    data_retention_time_in_days = each.value.data_retention_days
    }
