#######################
## Procject settings ##
#######################


variable "project_name" {
  description = "The name of the project that is the holder of the terraform state."
  default     = "my-project"
}
variable "snowflake_dbt_enabled" {
  type = bool

  default = false
}

variable "snowflake_prefect_enabled" {
  type = bool

  default = false
}

variable "snowflake_powerbi_enabled" {
  type = bool

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

########################
## Admin configuration ##
#########################
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
variable "snowflake_sso_integration" {
  type    = bool
  default = false
}

########################
## Database variables ##
########################

variable "default_dds_retention_time" {
  description = "The retention time for data within the defaul domain data store"
  type        = number
}
variable "snowflake_prod_source_databases" {
  type = list(object({
    name                 = string
    data_retention_days  = string
    clone_frequency_cron = string
    project_tag          = string
  }))
  default = []
}

variable "snowflake_dev_source_databases" {
  type = list(object({
    name                = string
    data_retention_days = string
    project_tag         = string

  }))
  default = []
}

variable "snowflake_delivery_databases" {
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


variable "snowflake_data_loader" {
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


variable "snowflake_additional_roles" {
  type    = list(string)
  default = []
}

variable "snowflake_schema_role_read" {
  type = list(object({
    name = string
  }))
  default = []
}
