
resource "snowflake_resource_monitor" "Snowflake_project_monitor"{
provider = snowflake.accountadmin
name = "PROJECT_MONITOR_${var.project_name}"
credit_quota = var.project_credit_quota
frequency = "MONTHLY"

start_timestamp = "2024-12-01 00:00"

notify_users = var.notify_user


notify_triggers = [50, 75, 100]
}
 
resource "snowflake_resource_monitor" "Snowflake_project_dev_monitor" {
provider = snowflake.accountadmin
name = "PROJECT_MONITOR_DEV_${var.project_name}"
credit_quota = var.project_dev_credit_quota
frequency = "MONTHLY"

start_timestamp = "2024-12-01 00:00"

notify_users =var.notify_user

notify_triggers = [50, 75]
suspend_trigger = 100
suspend_immediate_trigger = 110
}
resource "snowflake_resource_monitor" "snowflake_loader_monitor" {
provider = snowflake.accountadmin
  for_each = { for wh in var.snowflake_data_loader : wh.source => wh }
  name = "LOADER_MONITOR_${each.value.source}"
  credit_quota = each.value.quota
  frequency = "MONTHLY"

  start_timestamp = "2024-12-01 00:00"

}

