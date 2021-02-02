## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| availability\_zones | n/a | `list(string)` | n/a | yes |
| backtrack\_window | The AWS Aurora RDS backtrack window in seconds. Defaults to 0 seconds. | `number` | `0` | no |
| backup\_retention\_period | The AWS Aurora RDS backup retention period in days. Cannot be disabled. | `number` | `1` | no |
| cluster\_identifier | n/a | `string` | n/a | yes |
| database\_name | n/a | `string` | n/a | yes |
| enable\_iam\_auth | Enable the IAM authentication through RDS Proxy. Only in use when `rds_proxy.enable` is `true`. | `bool` | `false` | no |
| engine | The AWS Aurora engine to use. For instance: aurora, aurora-mysql, aurora-postgresql | `string` | n/a | yes |
| engine\_version | The AWS database engine version to use.<br>  You can use `aws rds describe-db-engine-versions --query "DBEngineVersions[].ValidUpgradeTarget[?Engine=='aurora-postgresql'].EngineVersion"` to get a list | `string` | n/a | yes |
| instance\_class | The instance class | `string` | n/a | yes |
| instance\_count | The number of database instances | `number` | n/a | yes |
| master\_password | n/a | `string` | n/a | yes |
| master\_username | n/a | `string` | n/a | yes |
| parameter\_group\_family | The RDS parameter group to use. For example: aurora-mysql5.7<br>  You can use `aws rds describe-db-engine-versions --query "DBEngineVersions[].DBParameterGroupFamily"` to get a list. | `string` | n/a | yes |
| rds\_proxy | In preview. Working in Progress. | `any` | <pre>{<br>  "enable": false<br>}</pre> | no |
| security\_group\_ids | The IDs of the security groups to associate to the RDS cluster | `list(string)` | n/a | yes |
| subnet\_ids | The list of subnet IDs to use for the AWS Aurora cluster | `list(string)` | n/a | yes |
| tags | The list of AWS Tags to use when creating the resources | `map(string)` | n/a | yes |

## Outputs

No output.