resource "snowflake_warehouse" "default_loading_warehouse" {
    provider = snowflake.sysadmin
    for_each = { for wh in var.snowflake_data_loader : wh.source => wh }
    name = "LOADING_DATA_${each.value.source}"
    warehouse_size = each.value.size
    auto_suspend = each.value.auto_suspend
    max_cluster_count = each.value.max_cluster_count
    min_cluster_count = each.value.min_cluster_count
    max_concurrency_level = each.value.max_concurrency_level
    scaling_policy = "ECONOMY"
    initially_suspended = true
    warehouse_type = "STANDARD" 
    auto_resume = true
    enable_query_acceleration = false
}

variable "snowflake_data_loader" { 
 type = list(object({
    source = string
    size = string
    auto_suspend = number
    max_cluster_count = number
    min_cluster_count = number
    max_concurrency_level = number
  }))
  default = [] 
}

resource "snowflake_warehouse" "default_prod_transformer" {
    provider = snowflake.sysadmin
    for_each = { for wh in var.snowflake_prod_transformer : wh.name => wh }
    name = "TRANSFORMER_${each.value.name}"
    warehouse_size = each.value.size
    auto_suspend = 60
    max_cluster_count = each.value.max_cluster_count
    min_cluster_count = each.value.min_cluster_count
    max_concurrency_level = each.value.max_concurrency_level
    scaling_policy = "ECONOMY"
    initially_suspended = true
    warehouse_type = "STANDARD" 
    auto_resume = true
    enable_query_acceleration = false
}

resource "snowflake_warehouse" "default_dev_transformer" {
  provider = snowflake.sysadmin
    for_each = { for wh in var.snowflake_dev_transformer : wh.name => wh }
    name = "DEV_TRANSFORMER_${each.value.name}"
    warehouse_size = each.value.size
    auto_suspend = 60
    max_cluster_count = each.value.max_cluster_count
    min_cluster_count = each.value.min_cluster_count
    max_concurrency_level = each.value.max_concurrency_level
    scaling_policy = "ECONOMY"
    initially_suspended = true
    warehouse_type = "STANDARD" 
    auto_resume = true
    enable_query_acceleration = false 
 
}

resource "snowflake_warehouse" "exstra_warehouse" {
 provider = snowflake.sysadmin
    for_each = { for wh in var.snowflake_extra_warehouses : wh.name => wh }
    name = "${each.value.name}"
    warehouse_size = each.value.size
    auto_suspend = each.value.auto_suspend
    max_cluster_count = each.value.max_cluster_count
    min_cluster_count = each.value.min_cluster_count
    max_concurrency_level = each.value.max_concurrency_level
    scaling_policy = each.value.scaling_policy
    initially_suspended = true
    warehouse_type = "STANDARD" 
    auto_resume = true
    enable_query_acceleration = false 
}
