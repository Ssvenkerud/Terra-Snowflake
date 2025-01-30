
resource "snowflake_database" "central_data_product_database" {
  provider = snowflake.sysadmin
  count    = var.snowflake_central_data_products_setup ? 1 : 0

  name                        = "DATA_PRODUCTS"
  comment                     = "This database acts as as central sharing layer for data between the teams"
  data_retention_time_in_days = var.default_dds_retention_time
}

resource "snowflake_database_role" "central_data_products_role_w" {
  provider = snowflake.sysadmin
  count    = var.snowflake_central_data_products_setup ? 1 : 0

  database = "DATA_PRODUCTS"

  name    = "AR_DB_DATA_PRODUCTS_W"
  comment = "database write access role"
}

resource "snowflake_database_role" "central_data_products_role_r" {
  provider = snowflake.sysadmin
  count    = var.snowflake_central_data_products_setup ? 1 : 0

  database = "DATA_PRODUCTS"

  name    = "AR_DB_DATA_PRODUCTS_R"
  comment = "database read access role"
}

resource "snowflake_database" "project_data_products_database" {
  provider = snowflake.sysadmin
  count    = var.snowflake_project_data_products_setup ? 1 : 0

  name                        = "DATA_PRODUCTS_${var.project_name}"
  comment                     = "This database acts as as central sharing layer for data between the teams"
  data_retention_time_in_days = var.default_dds_retention_time
}

resource "snowflake_database_role" "project_data_products_role_w" {
  provider = snowflake.sysadmin
  count    = var.snowflake_project_data_products_setup ? 1 : 0

  database = "DATA_PRODUCTS_${var.project_name}"

  name    = "AR_DB_DATA_PRODUCTS_${var.project_name}_W"
  comment = "database write access role"
}

resource "snowflake_database_role" "project_data_products_role_r" {
  provider = snowflake.sysadmin
  count    = var.snowflake_project_data_products_setup ? 1 : 0

  database = "DATA_PRODUCTS_${var.project_name}"

  name    = "AR_DB_DATA_PRODUCTS_${var.project_name}_R"
  comment = "database read access role"
}
