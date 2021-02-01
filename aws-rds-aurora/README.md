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
| backtrack\_window | The AWS Aurora RDS backtrack window in seconds. Cannot be disabled. Defaults to 30 minutes. | `number` | `1800` | no |
| backup\_retention\_period | The AWS Aurora RDS backup retention period in days. Cannot be disabled. | `number` | `1` | no |
| cluster\_identifier | n/a | `string` | n/a | yes |
| database\_name | n/a | `string` | n/a | yes |
| engine | The AWS Aurora engine to use. For instance: aurora, aurora-mysql, aurora-postgresql | `string` | n/a | yes |
| instance\_class | The instance class | `string` | n/a | yes |
| instance\_count | The number of database instances | `number` | n/a | yes |
| master\_password | n/a | `string` | n/a | yes |
| master\_username | n/a | `string` | n/a | yes |
| parameter\_group\_family | The RDS parameter group to use. For example: aurora-mysql5.7 | `string` | n/a | yes |
| rds\_proxy | In preview. Working in Progress. | `any` | <pre>{<br>  "enable": false<br>}</pre> | no |
| subnet\_ids | The list of subnet IDs to use for the AWS Aurora cluster | `list(string)` | n/a | yes |
| tags | The list of AWS Tags to use when creating the resources | `map(string)` | n/a | yes |

## Outputs

No output.