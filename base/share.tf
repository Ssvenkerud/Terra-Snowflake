

resource "snowflake_database" "outgoing_share_database" {
  provider = snowflake.accountadmin
  for_each = { for share in var.snowfake_outgoing_share : share.name => share }
  name     = "SHARE_OUTGOING_${each.value.name}"
}

