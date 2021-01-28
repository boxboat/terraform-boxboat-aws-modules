locals {
    rds_proxy_engine_value = upper(replace(replace(var.engine, "aurora", ""), "-", "")) //take-out aurora- and convert to uppercase
}