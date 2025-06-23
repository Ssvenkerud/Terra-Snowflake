resource "snowflake_share" "outgoing_share" {
  provider   = snowflake.accountadmin # notice the provider fields
  for_each   = { for share in var.snowfake_outgoing_share : share.name => share }
  name       = each.value.name
  accounts   = each.value.outgoing_accounts
  depends_on = [snowflake_database.outgoing_share_database]
}

variable "snowfake_outgoing_share" {
  type = list(map())
  default = [{
    name              = "",
    outgoing_accounts = []
  }]
}

resource "snowflake_database" "outgoing_share_database" {
  provider = snowflake.accountadmin
  for_each = { for share in var.snowfake_outgoing_share : share.name => share }
  name     = "SHARE_OUTGOING_${each.value.name}"
}

resource "snowflake_grant_privileges_to_share" "outgoing_share_grant" {
  provider    = snowflake.securityadmin
  to_share    = snowflake_share.outgoing_share
  privileges  = ["USAGE"]
  on_database = snowflake_database.outgoing_share_database.name
  depends_on  = [snowflake_database.outgoing_share_database, snowflake_share.outgoing_share]
}
