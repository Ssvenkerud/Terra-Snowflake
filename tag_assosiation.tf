resource "snowflake_tag_association" "db_association" {
  provider = snowflake.sysadmin

  object_identifier {
    name = snowflake_database.prod_source_database[*].name
  }
  object_type = "DATABASE"
  tag_id      = snowflake_tag.billing_tag.id
  tag_value   = var.project_name
}
