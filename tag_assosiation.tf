resource "snowflake_tag_association" "db_association" {
  provider = snowflake.sysadmin
  for_each = tolist(snowflake_database[*].fully_qualified_name)

  object_identifier {
    name = each.key
  }
  object_type = "DATABASE"
  tag_id      = snowflake_tag.billing_tag.id
  tag_value   = var.project_name
}
