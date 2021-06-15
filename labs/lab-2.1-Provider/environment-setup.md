# Lab Environment Setup

## Virtual Machine

For the labs in this class you will using a virtual machine that has been provisioned for you in AWS.  Your instructor will provide the following access information to you:
* Machine IP address
* SSH key

Save the SSH key in a temporary location on your local machine.  Then execute SSH from your local machine, substituting the appropriate values for \<machine-ip\> and \<path-to-ssh-key\>.  (If you get a message about authenticity of the host and asking if you want to continue, type 'yes'.)

```
ssh ubuntu@<machine-ip> -i <path-to-ssh-key>
```

## AWS Management Console

The infrastructure created using Terraform in this class' labs will be created in an AWS account dedicated for your use.  You instructor will provide the AWS account number and login credentials for you to access the AWS Management Console for the account.

In a browser, go to https://console.aws.amazon.com

Enter the account number and login credentials.  From the console, you will have read access to view the infrastructure you subsequently provision in the labs using Terraform.

You are now set to proceed with the class.
