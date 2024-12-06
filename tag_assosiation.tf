resource "snowflake_tag_association" "dds_db_association" {
  provider = snowflake.sysadmin

  object_identifier {
    name = "DDS_${var.project_name}"
  }
  object_type = "DATABASE"
  tag_id      = snowflake_tag.billing_tag.id
  tag_value   = var.project_name
}

resource "snowflake_tag_association" "prod_source_db_association" {
  provider = snowflake.sysadmin

  for_each = { for db in var.snowflake_prod_source_databases : db.name => db }

  object_identifier {
    name = "SOURCE_${each.value.name}"
  }
  object_type = "DATABASE"
  tag_id      = snowflake_tag.billing_tag.id
  tag_value   = var.project_name
}

resource "snowflake_tag_association" "dev_source_db_association" {
  provider = snowflake.sysadmin

  for_each = { for db in var.snowflake_dev_source_databases : db.name => db }

  object_identifier {
    name = "DEV_SOURCE_${each.value.name}"
  }
  object_type = "DATABASE"
  tag_id      = snowflake_tag.billing_tag.id
  tag_value   = var.project_name
}

resource "snowflake_tag_association" "delivery_db_association" {
  provider = snowflake.sysadmin

  for_each = { for db in var.snowflake_delivery_databases : db.name => db }

  object_identifier {
    name = "DDS_${each.value.name}"
  }
  object_type = "DATABASE"
  tag_id      = snowflake_tag.billing_tag.id
  tag_value   = var.project_name
}
###

resource "snowflake_tag_association" "delivery_db_association" {
  provider = snowflake.sysadmin

  for_each =  { for wh in var.snowflake_data_loader : wh.source => wh }

  object_identifier {
    name = "LOADING_DATA_${each.value.source}"
  }
  object_type = "WAREHOUSE"
  tag_id      = snowflake_tag.billing_tag.id
  tag_value   = var.project_name
}


resource "snowflake_tag_association" "delivery_db_association" {
  provider = snowflake.sysadmin

  for_each =  { for wh in var.snowflake_prod_transformer : wh.name => wh }

  object_identifier {
    name = "TRANSFORMER_${each.value.name}"
  }
  object_type = "WAREHOUSE"
  tag_id      = snowflake_tag.billing_tag.id
  tag_value   = var.project_name
}


resource "snowflake_tag_association" "delivery_db_association" {
  provider = snowflake.sysadmin

  for_each = { for wh in var.snowflake_dev_transformer : wh.name => wh }

  object_identifier {
    name = "DEV_TRANSFORMER_${each.value.name}"
  }
  object_type = "WAREHOUSE"
  tag_id      = snowflake_tag.billing_tag.id
  tag_value   = var.project_name
}


resource "snowflake_tag_association" "delivery_db_association" {
  provider = snowflake.sysadmin

  for_each =  { for wh in var.snowflake_extra_warehouses : wh.name => wh }

  object_identifier {
    name = "${each.value.name}"
  }
  object_type = "WAREHOUSE"
  tag_id      = snowflake_tag.billing_tag.id
  tag_value   = var.project_name
}
