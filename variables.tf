variable "project_name" {
  default = "my-project"
} 

variable "default_dds_retention_time" {
 description = "The retention time for data within the defaul domain data store"
 type = number 
}
