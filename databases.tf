resource "snowflake_database" "default_database" {
    provider = snowflake.sysadmin
    name = "DDS_${var.project_name}"
    comment = "The database containing project dataproducts"
    data_retention_time_in_days = var.default_dds_retention_time
    }


resource "snowflake_database" "prod_source_database"{
    provider = snowflake.sysadmin
    for_each = { for db in var.snowflake_prod_source_databases : db.name => db }
    name = "SOURCE_${each.value.name}"
    comment = "Production source database"
    data_retention_time_in_days = each.value.data_retention_days
    lifecycle {
    prevent_destroy = each.value.delete_protection
  }
    }

resource "snowflake_database" "dev_source_database"{
    provider = snowflake.sysadmin
    for_each = { for db in var.snowflake_dev_source_databases : db.name => db }
    name = "DEV_SOURCE_${each.value.name}"
    comment = "development source database"
    data_retention_time_in_days = each.value.data_retention_days
    lifecycle {
    prevent_destroy =  each.value.delete_protection

  }
    }

resource "snowflake_database" "delivery_database" {
    provider = snowflake.sysadmin
    for_each = { for db in var.snowflake_delivery_databases : db.name => db }
    name = "DDS_${each.value.name}"
    comment = "delivery database"
    data_retention_time_in_days = each.value.data_retention_days
    lifecycle {
    prevent_destroy =  each.value.delete_protection

  }
    }
