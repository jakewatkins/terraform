# terraform

repo for terraform stuff I'm learning

## vm-win-pro

Sets up a vm running Windows 11 Pro w/ a 1TB C drive.
-Enables PS Remote
-Enable automatic updates
-Give it a public IP address
-Expand the C drive so that it uses everything available
-Get the password from an Azure Keyvault

Before you can deploy the vm you need to first create a keyvault and then create a secret for the password. Remember the keyvault name and the secret name because you'll use them to update my files.
In vm-win-pro/data.tf change the keyvault name and the secret name to match the vaules you used.
In vm-win-pro/Variables.tf change the following:

- rgName to the name you wnat for your resource group
- machinename to the name you want for your workstations

In vm-win-pro/vm-up.ps change the following:

- on line 11 change the value for --name to the name of your secret
- on line 11 change the value for --vault-name to the name of your keyvault

Save everything. the run the following sequence:

- Terraform init
- ./vm-up.ps1

Once the script has finished you can RDP to the workstation and begin using it. When you're all done, just run "terraform destroy -auto-approve" and everything will be thrown away.
