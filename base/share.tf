

resource "snowflake_database" "outgoing_share_database" {
  provider = snowflake.sysadmin
  for_each = { for share in var.snowfake_outgoing_share : share.name => share }
  name     = "OUTGOING_SHARE_${each.value.name}"
}

