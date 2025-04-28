terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.99.0"
      configuration_aliases = [
        snowflake.sysadmin,
        snowflake.useradmin,
        snowflake.securityadmin
      ]
    }
  }
}


