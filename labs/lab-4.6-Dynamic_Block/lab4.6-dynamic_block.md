# Dynamic Blocks

Lab Objective:
- Implement a dynamic block to handle multiple security group rules

## Preparation

If you did not complete lab 4.5, you can simply copy the solution code from that lab (and do terraform apply) as the starting point for this lab.

## Lab

Open `bastion.tf` for edit.

Notice that within the security group resource, there are multiple ingress rule sub-blocks.  We will replace the multiple sub-blocks by a single dynamic block.

A dynamic block uses the for_each construct, which you now know requires a map of values by which to populate values for each iteration.  Since there are two security group rules, the map will have two keys.  What might you use as the map key for the different security rules?

Create a locals block in `bastion.tf`, add a new map with two keys (use the ingress rule description as the keys), and a sub-map for each key to specify the following values:
* port
*	protocol
*	cidr blocks

Try your hand at writing the map before looking at the solution below (or in bastion.tf in the solution directory).

<details>

 _<summary>Click to see solution for security group map</summary>_

```
locals {
  bastion_ingress = {
    "SSH Access" = {
      port     = 22
      protocol = "tcp"
      cidrs    = ["0.0.0.0/0"]
    }
    "VPN Access" = {
      port     = 1194
      protocol = "tcp"
      cidrs    = ["10.1.8.0/24"]
    }
  }
}
```
</details>

Now replace the security group ingress rules with a dynamic block.  Try your hand at it, then compare your code to the solution below (or in bastion.tf in the solution folder).

<details>

 _<summary>Click to see solution for dynamic block</summary>_

```
  dynamic "ingress" {
    for_each = local.bastion_ingress
    content {
      description = ingress.key
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidrs
    }
  }
```
</details>

When you are done, run terraform validate:
```
terraform validate
```

Run terraform plan.  If you have refactored the code correctly, the plan should come back with no changes to make.
```
terraform plan
```
