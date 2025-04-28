variable "snowflake_firehose_ingestion_tables" {
  type = map(map(list(string)))
  default = {
    test_db = {
      "Tables" = ["test_tbl", "tbl_two"]
    }
    test_db2 = {
      "Tables" = ["test_tbl", "tbl_two"]
    }
  }
}

variable "snowflake_firehose_ingestion_databases" {
  type = list(object({}))
  default = [{
    database       = "name"
    retention_days = 3
  }]
}

variable "snowflake_firehose_user" {
  description = "Settings for warehouse that are used for the data ingestion process. "
  type        = list(object({}))
  default = [{
    name      = "name"
    warehouse = "name"
  }]
}

variable "aws_firehose_public_key1" {
  description = "Primary public key for authentication to Snowflake, Must be on 1 line without header and trailer"
  type        = string
  sensitive   = true
}

variable "aws_firehose_public_key2" {
  description = "Secondary public key for authentication to Snowflake, Must be on 1 line without header and trailer"
  type        = string
  sensitive   = true
  default     = "not_set"
}

variable "project_name" {
  description = "The name of the project that is the holder of the terraform state."
  default     = "my-project"
}
