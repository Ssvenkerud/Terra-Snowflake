
resource "snowflake_resource_monitor" "Snowflake_project_monitor" {
name = "PROJECT_MONITOR_${var.project_name}"
credit_quota = var.project_credit_quata
frequency = "MONTHLY"

start_timestamp = "2024-12-01 00:00"

notify_users = var.notify_user

notify_triggers = [50, 75]
suspend_trigger = 90
suspend_immediate_trigger = 100
}
 
resource "snowflake_resource_monitor" "Snowflake_project_dev_monitor" {
name = "PROJECT_MONITOR_DEV_${var.project_name}"
credit_quota = var.project_dev_credit_quata
frequency = "MONTHLY"

start_timestamp = "2024-12-01 00:00"

notify_users = var.notify_user

notify_triggers = [50, 75]
suspend_trigger = 90
suspend_immediate_trigger = 100
}
resource "snowflake_resource_monitor" "snowflake_loader_monitor" {
  for_each = { for wh in var.snowflake_data_loader : wh.source => wh }
  name = "LOADER_MONITOR_${each.value.source}"
  credit_quota = each.value.quota
  frequency = "MONTHLY"

  start_timestamp = "2024-12-01 00:00"

}

resource "snowflake_resource_monitor" "extra_monitor" {
  for_each = { for wh in var.snowflake_extra_warehouses : wh.name => wh }
  
  name = "monitor_"
}
