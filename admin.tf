resource "snowflake_database" "system_database" {
  provider = snowflake.sysadmin
  count    = var.snowflake_admin_setup ? 1 : 0

  name                        = "SYSTEM"
  comment                     = "The database containing project dataproducts"
  data_retention_time_in_days = var.default_dds_retention_time
}


resource "snowflake_account_role" "data_admin" {
  provider = snowflake.useradmin
  count    = var.snowflake_admin_setup ? 1 : 0
  name     = "DATA_ADMIN"
}

resource "snowflake_account_role" "loader_admin" {
  provider = snowflake.useradmin
  count    = var.snowflake_admin_setup ? 1 : 0
  name     = "LOADER_ADMIN"
}



resource "snowflake_warehouse" "sys_warehouse" {
  provider              = snowflake.sysadmin
  name                  = "SYSTEM_${var.project_name}"
  warehouse_size        = "XSMALL"
  auto_suspend          = 60
  max_cluster_count     = 2
  min_cluster_count     = 1
  max_concurrency_level = 1
  #resource_monitor = "MONITOR_${var.project_name}"# Disabled due to currently requirring account adming for warehouse creation
  scaling_policy            = "ECONOMY"
  initially_suspended       = true
  warehouse_type            = "STANDARD"
  auto_resume               = true
  enable_query_acceleration = false
}


resource "snowflake_tag" "billing_tag" {
  provider = snowflake.sysadmin
  count    = var.snowflake_admin_setup ? 1 : 0

  database = "SYSTEM"
  schema   = "PUBLIC"
  name     = "PROJECT"
  comment  = "Tag used to ascribe ownership of objects and resoures to projects"
  depends_on = [
    snowflake_database.system_database,
    snowflake_warehouse.sys_warehouse
  ]
}
