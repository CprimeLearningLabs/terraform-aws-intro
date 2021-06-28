# Verifying Your Load-Balanced Cluster

If you want to verify that the load-balanced cluster actually works, you can follow the instructions below to install an HTTP server on the cluster VMs and then use the load balancer public DNS in a browser to make an HTTP request.

### Add a Nat Gateway

The instructions below require public Internet access from the cluster VMs to download the Apache package.  Since the cluster VMs are on a private subnet, you will need to add a NAT Gateway into your infrastructure to enable Internet access from the private subnet.  Some of the resources you will need to use include aws_nat_gateway and aws_route_table.

If you are up to a challenge, you can try to write this code on your own.  Compare your solution with the code in the `nat.tf` file in the solution folder.

### Log into Bastion Host

The cluster VMs are in a private subnet and can only be accessed indirectly via the bastion host.

From doing the labs, the public IP of the bastion host should be an output `bastion-public-ip`.  You can SSH to to the bastion host as follows (substituting the correct public IP):
```
ssh ubuntu@<bastion-public-ip>
```

*You may also be prompted to confirm that you want to connect. Enter "yes".*

### Connect to Cluster VMs and Install HTTP Server

> :warning: &nbsp; Before being able to use SSH from the bastion host, you will need to upload the SSH private key the bastion host.  You can put the key as a file named 'id_rsa' in the .ssh subdirectory of the ubuntu home directory.

From the bastion host, you can SSH to each of the cluster VMs. To SSH to the cluster VMs, you will need their private IPs since these machines do not have a public IP.  You can find those by viewing the cluster VMs in the AWS Management Console, or by using terraform show to see the state of the resources.

![AWS Console - VM 0 IP address](./images/aws-vm-0-ip.png "AWS Console - VM 0 IP address")

From the bastion host, ssh using the private IP of the new VMs.
```
ssh ubuntu@<vm-private-ip>
```

On each of the cluster VMs, run the following command to start a simple HTTP server on each VM.
```
sudo apt-get install -y apache2
```

Exit from the cluster VM and bastion host.


### Invoke HTTP Request from Browser

Get the DNS of the load balancer.  It is one of the outputs in your Terraform state.
```
terraform output load-balancer-dns
```

You can now go to a browser and use the DNS of the load balancer to hit the HTTP server on the VMs.  

![Browser - http load balancer](./images/http-lb.png "Browser - http load balancer")


## Lab Cleanup

When you are done with all the labs in this class and are satisfied with the results, please tear down everything you created by running terraform destroy:
```
terraform destroy
```

The destroy might take up to 10 minutes. (Destroying the internet gateway sometimes seems to take quite a while.)
