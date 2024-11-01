resource "snowflake_warehouse" "default_loading_warehouse" {
    provider = sysadmin
    for_each = var.snowflake_data_loader
    name = "LOADING_DATA_${each.key}"
    size = each.value
}

resource "snowflake_warehouse" "default_prod_transformer" {
    provider = sysadmin
    name = "TRANSFORMER_${var.project_name}"
    size = var.prod_transformer_size
}

resource "snowflake_warehouse" "default_dev_transformer" {
    provider = sysadmin
    name = "DEV_TRANSFORMER_${var.project_name}"
    size = var.dev_transformer_size
}

resource "snowflake_warehouse" "exstra_warehouse" {
  provider = sysadmin
  for_each = var.snowflake_warehouse
  name = each.value.name
  size = each.value.size
}
