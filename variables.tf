variable "project_name" {
  default = "my-project"
} 

variable "default_dds_retention_time" {
 description = "The retention time for data within the defaul domain data store"
 type = number 
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

