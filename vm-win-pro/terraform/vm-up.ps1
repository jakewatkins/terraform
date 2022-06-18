#
#
#
#
param($vmName)


# get the local machine's ip address
$workstationId = (Invoke-webrequest ifconfig.me/ip).Content.Trim()

# do the terraform stuff
Write-Host "running Terraform Plan"
terraform plan -var="workstation_ip=$workstationId" -var="machineName=$vmName"
Write-Host "Running Terraform Apply"
terraform apply -var="workstation_ip=$workstationId" -var="machineName=$vmName" -auto-approve
Write-host "finished creating VM - waiting 60 before starting bootstrap process"
start-sleep -seconds 60

Write-Host "Configuring VM for Chef Bootstrap"
#get password from the keyvault
$secret = (ConvertFrom-Json -InputObject ((az keyvault secret show --name SprinterPassword --vault-name  kvGPSecrets) -join " ")).value

#setup remote session
$username = 'sysadmin'
$password = ConvertTo-SecureString -string $secret -AsPlainText -Force

$credential = new-object -TypeName system.management.automation.pscredential -ArgumentList ($username, $password)

$session = new-pssession -computer vm-jkw-ws-sprinter.centralus.cloudapp.azure.com -Credential $credential
invoke-command -session $session -filepath ./files/config.ps1
exit-pssession

write-host 'waiting to give Azure a moment to rest'
start-sleep -seconds 60

write-host "boot strapping $vmName"

#$publicIp = az vm list-ip-addresses -n $vmName --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv
#$fdqn = (convertfrom-json -InputObject ((az network public-ip show --resource-group Sprinter -n vm_public_ip --query "{fdqn: dnsSettings.fqdn}") -join " ")).fdqn
#write-host "host - $fdqn - $publicIp - $vmName - $username - $password"
#knife bootstrap $publicIp -N $fdqn -o winrm --winrm-user $username --winrm-password $password --node-name $vmName -y
./bootstrap.ps1 $vmName
