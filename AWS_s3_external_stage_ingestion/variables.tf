

variable "snowflake_s3_sources" {
  type = list(map(string))
  default = [{
    source : "eir",
    s3_location : "s3://com.example.bucket/prefix"
    retention_days = "value2"
  }]
}
