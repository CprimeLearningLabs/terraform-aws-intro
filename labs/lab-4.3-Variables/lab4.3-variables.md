# Variables

Lab Objective:
- Add input variables to parameterize your configuration

# Preparation

If you did not complete lab 3.1, you can simply copy the solution code from that lab (and do terraform apply) as the starting point for this lab.

# Lab

First, think about what you might want to parameterize in the configuration you have defined so far.

:question: What variations might you want to support?  Should there be a default value for some parameters, and which parameters should be required?

Create a file called variables.tf

For this lab, we will create variables for the following:
-	Region
- VM key pair name
-	Database name

Try your hand at writing the variable declarations in variables.tf.  Run terraform validate to check for syntax errors.

Compare your code to the solution below (or to the variables.tf file in the solution folder).

<details>

 _<summary>Click to see solution for variables</summary>_

```
variable "region" {
  type = string
}

variable "vm_keypair_name" {
  description = "Name of the key pair for access to EC2 VMs"
  type = string
}

variable "db_name" {
  description = "Name of database to be created."
  type = string
  default = "appdb"
}
```
</details>

Now, use a variable reference to replace the corresponding target expressions in the configuration files.  There should be three places:

- Set the region local value in main.tf with var.region
- Set the key_name value for aws_instance in bastion.tf with var.vm_keypair_name
- Set the name value for aws_db_instance in database.tf with var.db_name

Run terraform validate to check for errors.

### Setting the Variable Values

Create a file called terraform.tfvars

Set the values for the variables in that file.  Keep the region the same as before to avoid recreating the entire infrastructure.

```
region = "us-west-2"
vm_keypair_name = "tf-lab-key"
```

Run terraform plan and confirm that no resources are changed.
```
terraform plan
```


### Extra Credit -- Validation

If you still have time, add a validation block for the vm_keypair_name variable in variables.tf to verify the value is not null and not an empty string.

```
variable "vm_keypair_name" {
  description = "Name of the key pair for access to EC2 VMs."
  type = string

  validation {
    condition = var.vm_keypair_name != null && length(var.vm_keypair_name) > 0
    error_message = "Key pair name cannot be null or empty string."
  }
}
```

Change the value of vm_keypair_name in <code>terraform.tfvars</code> file to an empty string ("").  Run terraform plan.  You should get an error.  Change the value back to a valid value of "tf-lab-key".
