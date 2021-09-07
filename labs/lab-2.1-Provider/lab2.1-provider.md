# Using a Provider

Lab Objective:
- Create an initial Terraform configuration by specifying a provider

## Preparation

Be sure to have completed the instructions on the "environment-access" page: [Verifying Environment Access](../environment-access/environment-access.md)

**NOTE:** All code for the labs in this class will be created and executed on the lab virtual machine.

## Lab

For this lab we will be using a provider called "random".

Create a file called `main.tf`:

```
touch main.tf
```

> If you are using a Windows workstation, you can create the file through the file explorer UI.  Be sure the file extension is ".tf" and not ".txt".

Open the file for edit.

In the file, create a terraform block to specify that "random" is a required provider.  We also specify that we want to use version 0.15.0 or above for the Terraform version.

```
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 2.3.0"
    }
  }
  required_version = "~> 0.15.0"
}
```

Add a provider block to configure the "random" provider. This provider does not require any special configuration.

```
provider "random" {
}
```

> For all the labs, the solution code for the lab is contained in the solution folder.  If you want to check your code or need some help, you can always look at or copy the solution code.

Save the file.

>  If you are doing the labs from a Windows machine, be sure to save the Terraform files with UTF-8 or ANSI encoding. (Notepad defaults to unicode encoding.)

To see what you have done, run the following command:

```
terraform providers
```

You should see the following output showing that Terraform recognizes the provider you are wanting to use.

![Terraform Providers](./images/tf-providers.png "Terraform Providers Output")
