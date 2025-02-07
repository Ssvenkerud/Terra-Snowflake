resource "snowflake_oauth_integration_for_custom_clients" "dbt_cloud" {
  provider = snowflake.accountadmin
  count    = var.snowflake_dbt_cloud_setup ? 1 : 0

  name                         = "DBT_CLOUD_SSO"
  oauth_client_type            = "CONFIDENTIAL"
  oauth_redirect_uri           = var.dbt_cloud_uri
  enabled                      = "true"
  blocked_roles_list           = ["ACCOUNTADMIN", "SECURITYADMIN", "SYSADMIN", "USERADMIN", "DATA_ADMIN"]
  oauth_issue_refresh_tokens   = "true"
  oauth_refresh_token_validity = var.dbt_oauth_issue_refresh_tokens
  comment                      = "integration for DBT cloud user authenticaition"
}


resource "snowflake_saml2_integration" "OKTA_SSO" {
  provider                  = snowflake.accountadmin
  count                     = var.snowflake_okta_sso_setup ? 1 : 0
  allowed_email_patterns    = var.allowed_sso_email_patterns
  allowed_user_domains      = var.allowed_sso_email_domain
  comment                   = "Terraform managed integration"
  enabled                   = true
  name                      = "SSO_OKTA_INTEGRATION"
  saml2_enable_sp_initiated = true
  saml2_force_authn         = false
  saml2_issuer              = var.sso_idp_entity_id
  saml2_provider            = "OKTA"
  saml2_sso_url             = var.sso_url
  saml2_x509_cert           = file(var.saml2_x509_cert)
}
