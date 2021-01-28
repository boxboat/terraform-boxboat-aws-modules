locals {
    is_mysql_bit = [var.engine == "aurora-mysql" ? "1":"0"]
    is_postgres_bit = [var.engine == "aurora-postgresql" ? "1":"0"]
    rds_proxy_engine_value = upper(replace(replace(var.engine, "aurora", ""), "-", "")) //take-out aurora- and convert to uppercase
}