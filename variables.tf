variable "project_name" {
  default = "my-project"
} 

variable "prod_source_databases" {
  default = []
}

variable "dev_source_databases" {
  default = []
}
variable "delivery_databases" {
  default = []
}

variable "data_loader" {
  default = []
}

variable "SSO_integration" {
  default = []
}
