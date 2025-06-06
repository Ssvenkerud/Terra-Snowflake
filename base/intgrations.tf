resource "snowflake_oauth_integration_for_custom_clients" "dbt_cloud" {
  provider = snowflake.accountadmin
  count    = var.snowflake_dbt_cloud_setup ? 1 : 0

  name                         = "DBT_CLOUD_SSO"
  oauth_client_type            = "CONFIDENTIAL"
  oauth_redirect_uri           = var.dbt_cloud_uri
  enabled                      = "true"
  oauth_issue_refresh_tokens   = "true"
  oauth_refresh_token_validity = var.dbt_oauth_issue_refresh_tokens
  comment                      = "integration for DBT cloud user authenticaition"
}


resource "snowflake_saml2_integration" "OKTA_SSO" {
  provider                            = snowflake.accountadmin
  count                               = var.snowflake_okta_sso_setup ? 1 : 0
  comment                             = "Terraform managed integration"
  enabled                             = true
  name                                = "SSO_OKTA_INTEGRATION"
  saml2_enable_sp_initiated           = true
  saml2_force_authn                   = false
  saml2_issuer                        = var.sso_idp_entity_id
  saml2_provider                      = "OKTA"
  saml2_sso_url                       = var.sso_url
  saml2_x509_cert                     = var.saml2_x509_cert
  saml2_sp_initiated_login_page_label = "OKTA SSO"
  saml2_snowflake_acs_url             = var.snowflake_acs_url
  saml2_snowflake_issuer_url          = var.snowflake_issuer_url
}

resource "snowflake_storage_integration" "s3_integration" {
  provider                  = snowflake.accountadmin
  count                     = var.snowflake_aws_s3_integration ? 1 : 0
  name                      = "S3_STORAGE"
  comment                   = "This integration is purposfully left open, and the access limitation is done on the AWS IAM role."
  type                      = "EXTERNAL_STAGE"
  storage_allowed_locations = ["*"]
  enabled                   = true
  storage_provider          = "S3"
  storage_aws_role_arn      = var.snowflake_aws_s3_integration_role

}
