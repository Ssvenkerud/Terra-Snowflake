terraform {
  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
      configuration_aliases = [
        snowflake.sysadmin,
        snowflake.useradmin,
        snowflake.securityadmin
      ]
    }
  }
}


