
resource "snowflake_database" "central_data_product_database" {
  provider = snowflake.sysadmin
  count    = var.snowflake_central_data_products_setup ? 1 : 0

  name                        = "DATA_PRODUCTS"
  comment                     = "This database acts as as central sharing layer for data between the teams"
  data_retention_time_in_days = var.default_dds_retention_time
}
resource "snowflake_database" "central_dev_data_product_database" {
  provider = snowflake.sysadmin
  count    = var.snowflake_central_data_products_setup ? 1 : 0

  name                        = "DEV_DATA_PRODUCTS"
  comment                     = "This database acts as as central sharing layer for data between the teams"
  data_retention_time_in_days = var.default_dds_retention_time
}
resource "snowflake_account_role" "central_data_products_role_w" {
  provider = snowflake.securityadmin
  count    = var.snowflake_central_data_products_setup ? 1 : 0


  name       = "AR_DB_DATA_PRODUCTS_W"
  comment    = "database write access role"
  depends_on = [snowflake_database.central_data_product_database]

}

resource "snowflake_account_role" "central_data_products_role_r" {
  provider = snowflake.securityadmin
  count    = var.snowflake_central_data_products_setup ? 1 : 0


  name       = "AR_DB_DATA_PRODUCTS_R"
  comment    = "database read access role"
  depends_on = [snowflake_database.central_data_product_database]
}
resource "snowflake_account_role" "central_dev_data_products_role_w" {
  provider = snowflake.securityadmin
  count    = var.snowflake_central_data_products_setup ? 1 : 0


  name       = "DEV_AR_DB_DATA_PRODUCTS_W"
  comment    = "database write access role"
  depends_on = [snowflake_database.central_dev_data_product_database]

}

resource "snowflake_account_role" "central_dev_data_products_role_r" {
  provider = snowflake.securityadmin
  count    = var.snowflake_central_data_products_setup ? 1 : 0


  name       = "DEV_AR_DB_DATA_PRODUCTS_R"
  comment    = "database read access role"
  depends_on = [snowflake_database.central_dev_data_product_database]
}


resource "snowflake_database" "project_data_products_database" {
  provider = snowflake.sysadmin
  count    = var.snowflake_project_data_products_setup ? 1 : 0

  name                        = "DATA_PRODUCTS_${var.project_name}"
  comment                     = "This database acts as as central sharing layer for data between the teams"
  data_retention_time_in_days = var.default_dds_retention_time
}
resource "snowflake_database" "dev_project_data_products_database" {
  provider = snowflake.sysadmin
  count    = var.snowflake_project_data_products_setup ? 1 : 0

  name                        = "DEV_DATA_PRODUCTS_${var.project_name}"
  comment                     = "This database acts as as central sharing layer for data between the teams"
  data_retention_time_in_days = var.default_dds_retention_time
}
resource "snowflake_account_role" "project_data_products_role_w" {
  provider = snowflake.securityadmin
  count    = var.snowflake_project_data_products_setup ? 1 : 0


  name       = "AR_DB_DATA_PRODUCTS_${var.project_name}_W"
  comment    = "database write access role"
  depends_on = [snowflake_database.project_data_products_database]

}

resource "snowflake_account_role" "project_data_products_role_r" {
  provider = snowflake.securityadmin
  count    = var.snowflake_project_data_products_setup ? 1 : 0


  name       = "AR_DB_DATA_PRODUCTS_${var.project_name}_R"
  comment    = "database read access role"
  depends_on = [snowflake_database.project_data_products_database]
}

resource "snowflake_account_role" "dev_project_data_products_role_w" {
  provider = snowflake.securityadmin
  count    = var.snowflake_project_data_products_setup ? 1 : 0

  name       = "DEV_AR_DB_DATA_PRODUCTS_${var.project_name}_W"
  comment    = "database write access role"
  depends_on = [snowflake_database.dev_project_data_products_database]
}

resource "snowflake_account_role" "dev_project_data_products_role_r" {
  provider = snowflake.securityadmin
  count    = var.snowflake_project_data_products_setup ? 1 : 0

  name       = "DEV_AR_DB_DATA_PRODUCTS_${var.project_name}_R"
  comment    = "database read access role"
  depends_on = [snowflake_database.dev_project_data_products_database]
}
