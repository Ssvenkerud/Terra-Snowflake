resource "snowflake_tag_association" "dds_db_association" {
  provider = snowflake.sysadmin

  object_identifiers = [snowflake_database.default_database.fully_qualified_name]
  object_type        = "DATABASE"
  tag_id             = snowflake_tag.billing_tag[1].id
  tag_value          = var.project_name
}

resource "snowflake_tag_association" "prod_source_db_association" {
  provider = snowflake.sysadmin

  for_each = { for db in var.snowflake_prod_source_databases : db.name => db }

  object_identifiers = [snowflake_database.prod_source_database[each.value.name].fully_qualified_name]
  object_type        = "DATABASE"
  tag_id             = snowflake_tag.billing_tag[1].id
  tag_value          = var.project_name
}

resource "snowflake_tag_association" "dev_source_db_association" {
  provider = snowflake.sysadmin

  for_each = { for db in var.snowflake_dev_source_databases : db.name => db }

  object_identifiers = [snowflake_database.dev_source_database[each.value.name].fully_qualified_name]
  object_type        = "DATABASE"
  tag_id             = snowflake_tag.billing_tag[1].id
  tag_value          = var.project_name
}

resource "snowflake_tag_association" "delivery_db_association" {
  provider = snowflake.sysadmin

  for_each = { for db in var.snowflake_delivery_databases : db.name => db }

  object_identifiers = [snowflake_database.delivery_database[each.value.name].fully_qulaified_name]
  object_type        = "DATABASE"
  tag_id             = snowflake_tag.billing_tag[1].id
  tag_value          = var.project_name
  depends_on         = [snowflake_tag.billing_tag]
}
###

resource "snowflake_tag_association" "loading_warehouse_association" {
  provider = snowflake.sysadmin

  for_each = { for wh in var.snowflake_data_loader : wh.source => wh }

  object_identifiers = [snowflake_warehouse.default_loading_warehouse[each.value.source].fully_qualified_name]
  object_type        = "WAREHOUSE"
  tag_id             = snowflake_tag.billing_tag[1].id
  tag_value          = var.project_name
  depends_on         = [snowflake_tag.billing_tag]
}


resource "snowflake_tag_association" "prod_transformer_association" {
  provider = snowflake.sysadmin

  for_each = { for wh in var.snowflake_prod_transformer : wh.name => wh }

  object_identifiers = [snowflake_warehouse.default_prod_transformer[each.value.name].fully_qualiaified_name]
  object_type        = "WAREHOUSE"
  tag_id             = snowflake_tag.billing_tag[1].id
  tag_value          = var.project_name
  depends_on         = [snowflake_tag.billing_tag]
}


resource "snowflake_tag_association" "dev_transformer_association" {
  provider = snowflake.sysadmin

  for_each = { for wh in var.snowflake_dev_transformer : wh.name => wh }

  object_identifiers = [snowflake_warehouse.default_dev_transformer[each.value.name]]
  object_type        = "WAREHOUSE"
  tag_id             = snowflake_tag.billing_tag[1].id
  tag_value          = var.project_name
  depends_on         = [snowflake_tag.billing_tag]
}


resource "snowflake_tag_association" "extra_warehouses_association" {
  provider = snowflake.sysadmin

  for_each = { for wh in var.snowflake_extra_warehouses : wh.name => wh }

  object_identifiers = [snowflake_warehouse.exstra_warehouse[each.value.name].fully_qualified_name]
  object_type        = "WAREHOUSE"
  tag_id             = snowflake_tag.billing_tag[1].id
  tag_value          = var.project_name
  depends_on         = [snowflake_tag.billing_tag]
}
