## Running the sample

```bash

cd examples/terraform-trigger-feature-branch

aws configure

terraform init

terraform plan -out "example.tfplan"

terraform apply "example.tfplan"

# verify it works

# clean up when done
terraform destroy 
```
