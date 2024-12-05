resource "snowflake_tag_association" "db_association" {
  provider = snowflake.sysadmin
  for_each = {for db in local.all_prod_databases : db.name => db}

  object_identifier {
    name = each.key
  }
  object_type = "DATABASE"
  tag_id      = snowflake_tag.billing_tag.id
  tag_value   = var.project_name
}
