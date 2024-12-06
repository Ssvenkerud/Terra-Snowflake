resource "snowflake_tag" "billing_tag" {
 provider = snowflake.sysadmin
 database = "DDS_${var.project_name}"
 schema = "PUBLIC"
 name = "PROJECT"
 comment = "Tag used to ascribe ownership of objects and resoures to projects"
}
