variable "project_name" {
  default = "my-project"
} 

variable "snowflake_prod_source_databases" {
  type = list(object({
    source = string
    data_retention_days = string
  }))
  default = []
}

variable "snowflake_dev_source_databases" {
  type = list(object({
    source = string
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

variable "snowflake_export_databases" {
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
    }
  ))
  default = [
  {
  source = "demo"
  size = "xsmall"
  }]
}

variable "snowflake_warehouse" {
  type = list(object({
    name = string
    size = string
    }
  ))
  default = [
  {
  name = "transformer"
  size = "xsmall"
  }]
}

variable "snowflake_additional_roles" {
 type = list(string)
 default = []
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



variable "snowflake_sso_integration" {
  default = []
}
