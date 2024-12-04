resource "snowflake_database" "default_database" {
    provider = snowflake.sysadmin
    name = "DDS_{var.project_name}"
    comment = "The database containing project dataproducts"
    data_retention_time_in_days = var.default_dds_retention_time
    }


