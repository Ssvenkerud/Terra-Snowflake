#######################
## Procject settings ##
#######################

#   These variables configure cetntral concepts of the project holding the state file.
#   They determin the behaviour of the module at a project level settings.


variable "project_name" {
  description = "The name of the project that is the holder of the terraform state."
  default     = "my-project"
}
variable "snowflake_dbt_enabled" {
  description = "Are you using DBT to manage the data platform, enabeling this variable creates a project SYS_DBT user"
  type        = bool

  default = false
}

variable "snowflake_prefect_enabled" {
  description = "If you are using Prefect to perform grand orchestration, enabeling this creates the system user for Prefect"
  type        = bool

  default = false
}

variable "snowflake_powerbi_enabled" {
  description = "If you need a system PowerBI user, enabeling this variable creates this user for the given project"
  type        = bool

  default = false
}

################
## Monitoring ##
################

variable "project_credit_quota" {
  type    = number
  default = 3000
}

variable "project_dev_credit_quota" {
  type    = number
  default = 3000
}
variable "notify_user" {
  description = "The username of the user to recive notifications for resource monitoring"
  type        = list(string)
  default     = [""]
}

variable "monitor_start" {
  type    = string
  default = "2024-12-01 00:00"
}

###################### 
#  SSO Configuration # 
######################

variable "snowflake_sso_integration" {
  description = "If you are using a SSP integration set this variable to true, if it is false, additional roles and objects are created, that normally would be managed by the SSO integration."
  type        = bool
  default     = false
}
variable "snowflake_okta_sso_setup" {
  description = "set to true, if you are using OKTA as you IDP"
  type        = bool

  default = false
}
variable "sso_idp_entity_id" {
  sensitive   = true
  description = "The string containing the IdP EntityID / Issuer."
  type        = string
  default     = "foo"
}
variable "sso_url" {
  sensitive   = true
  description = "The string containing the IdP SSO URL, where the user should be redirected by Snowflake (the Service Provider) with a SAML AuthnRequest"
  type        = string
  default     = "foo"
}
variable "saml2_x509_cert" {
  sensitive   = true
  description = "path to SAML cert, must be pem formanted"
  type        = string
  default     = "adda/badda.pem"
}
variable "snowflake_acs_url" {
  sensitive   = true
  description = "The string containing the Snowflake Assertion Consumer Service URL to which the IdP will send its SAML authentication response back to Snowflake."
  type        = string
  default     = "https://example.snowflakecomputing.com/fed/login"
}
variable "snowflake_issuer_url" {
  sensitive   = true
  description = "The string containing the EntityID / Issuer for the Snowflake service provider."
  type        = string
  default     = "https://example.snowflakecomputing.com"
}




########################
## Admin configuration ##
#########################

#   This configuration is set only once per account.
#   The settings in this block relates to acount wide settings that are needed for the 
#   module to function correctly.
#   As such these variables need to be enabled on the first project to be configured on a given
#   account. Thus making it the andmin project.


variable "snowflake_admin_setup" {
  description = "Is this the admin project for the snowflake account, holding the inital central objects"
  type        = bool

  default = false
}

variable "snowflake_central_internal_share_setup" {
  description = "Use a singel database to use as a internal sharing object"
  type        = bool

  default = false
}
variable "snowflake_project_internal_share_setup" {
  description = "Use a database per project used for internal sharing"
  type        = bool

  default = false
}

variable "snowflake_central_data_products_setup" {
  description = "Use a single database that acts as a presentation layer"
  type        = bool

  default = false
}
variable "snowflake_project_data_products_setup" {
  description = "Use a database per procjet as the presentation layer"
  type        = bool

  default = false
}
variable "snowflake_permifrost_enabled" {
  description = "Wheter to create users roles and grants to manage permissions with Permifrost"
  type        = bool

  default = false
}
variable "PERMIFROST_KEY" {
  description = "The path to the public key assigned to the Permifrost user for access controll. This is set as an enviroment variable"
  type        = string
  sensitive   = true

}
variable "snowflake_aws_s3_integration" {
  description = "Use a single database that acts as a presentation layer"
  type        = bool

  default = false
}

##################
## Integrations ##
##################

variable "snowflake_aws_s3_integration_role" {
  type    = string
  default = ""
}

variable "snowflake_powerbi_issuer" {
  type        = string
  description = "This variagle holds the issuer string for the entraId IdP"
  default     = ""
}
variable "snowflake_powerbi_allowed_roles" {
  description = "list of roles that can be used to access snowflake from PowerBI"
  type        = list(string)
  default     = []
}

####################
## DBT CLOUD setuo ##
#####################

variable "snowflake_dbt_cloud_setup" {
  description = "Is this the admin project for the snowflake account, holding the inital central objects"
  type        = bool

  default = false
}
variable "dbt_cloud_uri" {
  sensitive = true
  type      = string
  default   = ""
}

variable "dbt_oauth_issue_refresh_tokens" {
  description = "The retention time for data within the defaul domain data store"
  type        = number
}

########################
## Database variables ##
########################

#   These variables govern the creation and settings related to databases within the data platform
#   The variables all take lists of objects each creating the databases, and all roles needed to create
#   the RBAC system as will.

variable "default_dds_retention_time" {
  description = "The retention time for data within the defaul domain data store"
  type        = number
}
variable "snowflake_prod_source_databases" {
  description = "Databases that only have an ingestion process to Production. This database will also be cloned to the DEV enviroment at the given frequency."
  type = list(object({
    name                 = string
    data_retention_days  = string
    clone_frequency_cron = string
    project_tag          = string
  }))
  default = []
}

variable "snowflake_dev_source_databases" {
  description = "Databases where there exits a valid ingestion process both for the Prod and Dev data. Thus not needing a cloning step, and both prod and dev databases are created as native databases."
  type = list(object({
    name                = string
    data_retention_days = string
    project_tag         = string

  }))
  default = []
}

variable "snowflake_delivery_databases" {
  description = "Contains a list of additional Domain databases that are linked to the particular project. Here the full name needs to be given, as there is no automation on naming. This also creatyes both Dev and Pros databases."
  type = list(object({
    name                = string
    data_retention_days = string
    project_tag         = string

  }))
  default = []
}

#########################
## warehouse variables ##
#########################

# This block features configuration setttings for warehouses.
# The Granularity here is greater than for other configuratons, 
# in order to suport any posible future use cases.

variable "snowflake_data_loader" {
  description = "Settings for warehouse that are used for the data ingestion process. "
  type = list(object({
    source                = string
    size                  = string
    auto_suspend          = number
    max_cluster_count     = number
    min_cluster_count     = number
    max_concurrency_level = number
    quota                 = number
    project_tag           = string
  }))
  default = []
}

variable "snowflake_prod_transformer" {
  description = "If DBT is enabled, this is the default warehouse for DBT to create object in prod."
  type = list(object({
    name                  = string
    size                  = string
    auto_suspend          = number
    max_cluster_count     = number
    min_cluster_count     = number
    max_concurrency_level = number
  }))
  default = []
}

variable "snowflake_dev_transformer" {
  description = "The default warehouse used by data engineers during the development of transformations processes"
  type = list(object({
    name                  = string
    size                  = string
    auto_suspend          = number
    max_cluster_count     = number
    min_cluster_count     = number
    max_concurrency_level = number
  }))
  default = []
}


variable "snowflake_extra_warehouses" {
  description = "In the case one needs additional warehouses, these are configgured here. No naming automation is employed here."
  type = list(object({
    name                  = string
    size                  = string
    auto_suspend          = number
    max_cluster_count     = number
    min_cluster_count     = number
    max_concurrency_level = number
    scaling_policy        = string

    project_tag = string
  }))
  default = []
}


#####################
## Roles variabled ##
#####################

#   The wast majority of roles needed in the data platform creation is automated with this module.
#   However there is reason to asume that there will be neccecary to create additional roles not
#   covered by automation. Thus this block supports the creation of new roles that are not created automaticaly.

variable "snowflake_schema_role_read" {
  description = "The creation of AR roles that contains the prefix denominating them as Schema only roles."
  type = list(object({
    name = string
  }))
  default = []
}

variable "snowflake_additional_roles" {
  description = "Creation of any roles that are not created automatically."
  type        = list(string)
  default     = []
}

############
## SHARES ## 
############

variable "snowfake_outgoing_share" {
  type = list(object({
    name              = string
    outgoing_accounts = list(string)
  }))
}

