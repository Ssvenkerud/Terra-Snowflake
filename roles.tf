resource "snowflake_role" "loader_role" {
    provider = snowflake.useradmin
    for_each = var.snowflake_data_loader
    name = "LOADER_${each.key}"
    comment = "role for dataloaders"
}

resource "snowflake_role" "transformer_role" {
    provider = snowflake.useradmin
    name = "TRANSFORMER_${var.project_name}"
    comment = "role for the sytem user for production transformation"
}

resource "snowflake_role" "sso_data_engineer" {
    provider = snowflake.useradmin
    count = var.snowflake_sso_integration ? 1:0
    name = "DATA_ENGINEER_${var.project_name}"
}

resource "snowflake_role" "sso_data_analyst" {
    provider = snowflake.useradmin
    count = var.snowflake_sso_integration ? 1:0
    name = "DATA_ANALYST_${var.project_name}"
}

resource "snowflake_role" "non_sso_data_engineer" {
    provider = snowflake.useradmin
    count = var.snowflake_sso_integration ? 0:1
    name = "DATA_ENGINEER_${var.project_name}"
}

resource "snowflake_role" "non_sso_data_analyst" {
    provider = snowflake.useradmin
    count = var.snowflake_sso_integration ? 0:1
    name = "DATA_ANALYST_${var.project_name}"
}

resource "snowflake_role" "Powerbi_role" {
  provider = snowflake.useradmin
  count = var.snowflake_powerbi_enabled ? 1:0
  name = "POWERBI_${var.project_name}"
}

resource "snowflake_role" "extra_roles" {
  provider = snowflake.useradmin
  for_each = toset(var.snowflake_additional_roles)
  name = each.key
}
