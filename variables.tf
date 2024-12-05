variable "project_name" {
  default = "my-project"
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
variable "snowflake_permifrost_enabled" {
  type = bool

  default = false
}
variable "snowflake_sso_integration" {
  type = list(string)
  default = []
}


variable "default_dds_retention_time" {
 description = "The retention time for data within the defaul domain data store"
 type = number 
}
variable "snowflake_prod_source_databases" {
  type = list(object({
    name = string
    data_retention_days = string
  }))
  default = []
}

variable "snowflake_dev_source_databases" {
  type = list(object({
    name = string
    data_retention_days = string

  }))
  default = []
}

variable "snowflake_delivery_databases" {
  type = list(object({
    name = string
    data_retention_days = string

  }))
  default = []
}
variable "snowflake_data_loader" { 
 type = list(object({
    source = string
    size = string
    auto_suspend = number
    max_cluster_count = number
    min_cluster_count = number
    max_concurrency_level = number
  }))
  default = [] 
}

variable "snowflake_prod_transformer" { 
 type = list(object({
    name = string
    size = string
    auto_suspend = number
    max_cluster_count = number
    min_cluster_count = number
    max_concurrency_level = number
  }))
  default = [] 
}

variable "snowflake_dev_transformer" { 
 type = list(object({
    name = string
    size = string
    auto_suspend = number
    max_cluster_count = number
    min_cluster_count = number
    max_concurrency_level = number
  }))
  default = [] 
}


variable "snowflake_extra_warehouses" { 
 type = list(object({
    name = string
    size = string
    auto_suspend = number
    max_cluster_count = number
    min_cluster_count = number
    max_concurrency_level = number
  }))
  default = [] 
}

variable "snowflake_additional_roles" {
    type = list(string)
    default = []
}

variable "snowflake_schema_role_read" {
    type = list(object({
        name = string
    }))
    default = []
}
