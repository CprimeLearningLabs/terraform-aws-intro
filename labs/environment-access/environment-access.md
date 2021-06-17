# Lab Environment Access

The labs for this class will require that you have access to the AWS Management Console and to a provisioned lab workstation.

## AWS Management Console

The infrastructure created using Terraform in this class' labs will be created in an AWS account dedicated for your use.  You instructor will provide the AWS account number and login credentials for you to access the AWS Management Console for the account.

In a browser, go to https://console.aws.amazon.com

Enter the account number and login credentials.  From the console, you will have read access to view the infrastructure you subsequently provision in the labs using Terraform.

## Workstation Virtual Machine

For the labs in this class you will using a virtual machine that has been provisioned for you in AWS.  You can choose between a Linux workstation or a Windows workstation.  Follow the instruction in the appropriate sub-section below.

### Linux Workstation

Your instructor will provide the following access information to you:
* Machine IP address
* SSH key

Save the SSH key in a temporary location on your local machine.  Then execute SSH from your local machine, substituting the appropriate values for \<machine-ip\> and \<path-to-ssh-key\>.  (If you get a message about authenticity of the host and asking if you want to continue, type 'yes'.)

```
ssh ubuntu@<machine-ip> -i <path-to-ssh-key>
```

### Windows Workstation

Your instructor will provide the following access information to you:
* Machine IP address
* User credentials (username and password)

Using Putty or Windows Remote Desktop from your local machine, enter the provided information to connect to the Windows machine.
