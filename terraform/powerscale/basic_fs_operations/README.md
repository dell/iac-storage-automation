# Basic file operations in Dell PowerScale using Terraform
In this example you can see how to use PowerScale resources to carry out basic file system operations in Dell PowerScale. Before you begin, please make sure:
- You have a PowerScale cluster up and running
- You have a user group named "Guests"  
- Update the `provider.tf` file with the latest PowerScale provider version and access credentials for PowerScale cluster
- Update the `variables.tf` as needed

## Workflow automated in this example
main.tf file in this example automates the following workflow:
1. Gets the details of the Guests user group using the data source
2. Creates a user in the Guests user group
3. Creates a File System with user in step 2 as the owner
4. Creates an NFS export for the file system created in step 3
5. Creates a snapshot of the file system created in step 3

## Steps to run the example
1. `terraform init` to initialize the working directory
2. `terraform plan` to create an execution plan
3. `terraform apply` to apply the desired changes
4. You can check the changes in the OneFS user interfaces under different sections to see the updates. 
5. You can also use `terraform destroy` to destroy the resources created in the example 

Please visit the [Dell PowerScale Terraform Provider documentation](https://registry.terraform.io/providers/dell/powerscale/latest/docs) or the [GitHub repository for the provider](https://github.com/dell/terraform-provider-powerscale/tree/main/examples) for more details on the resources and data sources that you can use.
```