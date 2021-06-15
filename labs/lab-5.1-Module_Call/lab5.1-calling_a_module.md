# Calling a Module

Lab Objective:
- Use a module to create a dynamodb table

## Preparation

If you did not complete lab 4.7, you can simply copy the solution code from that lab (and do terraform apply) as the starting point for this lab.

## Lab

Go the Terraform registry (https://registry.terraform.io/search/modules?provider=aws) to see what modules are available for creating a DynamoDB table.  What do you find?

The module we want to use in this lab is at:

* https://registry.terraform.io/modules/terraform-aws-modules/dynamodb-table/aws/1.0.0

Be sure to select version 1.1.0.

Look through the module documentation to see how it should be used.  Look at the inputs section to see what input arguments are required versus optional. (Actually, some of the required variables are not really required.)

Open `database.tf`

Using the module documentation as a guide, add a call to the module to create a dynamodb table:
* Hash key name is "Property"
* No range key
* Table name is "terraform-labs-kvstore"

Specify the version explicitly as "1.1.0" since that is what this lab was based on.

Compare your code to the solution below (or in the database.tf file in the solution folder).

<details>

 _<summary>Click to see solution for module call</summary>_

```
module "dynamodb" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "1.1.0"

  name     = "terraform-labs-kvstore"
  hash_key = "Property"

  attributes = [
    {
      name = "Property"
      type = "S"
    }
  ]
}
```
</details>

If you try running terraform validate at this point, you would get an error that you must first run terraform init.  Do you know why you would need to call init?

![Terraform Validate - Run init for module](./images/tf-init-error.png "Terraform Validate - Run init for module")

Run terraform init:
```
terraform init
```

Run terraform validate:
```
terraform validate
```

Run terraform plan.
```
terraform plan
```

Run terraform apply:
```
terraform apply
```
