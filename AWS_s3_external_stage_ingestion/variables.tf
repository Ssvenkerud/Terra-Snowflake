

variable "snowflake_s3_sources" {
  type = list(map())
  default = [{
    "source" : "eir",
    "s3_location" : "s3://com.example.bucket/prefix"
  }]
}
