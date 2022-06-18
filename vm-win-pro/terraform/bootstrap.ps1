#
#
#
#
param($vmName)


if (!$vmName) {
    write-host "please provide the name of the vm to be bootstrapped."
    exit
}

write-host "bootstrapping $vmName"

$publicIp = az vm list-ip-addresses -n $vmName --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv
$fdqn = (convertfrom-json -InputObject ((az network public-ip show --resource-group Sprinter -n vm_public_ip --query "{fdqn: dnsSettings.fqdn}") -join " ")).fdqn

write-host "IP: $publicIp"
write-host "DNS: $fdqn"

write-host "boot strapping $fdqn"
knife bootstrap $publicIp -N $fdqn -o winrm --winrm-user sysAdmin --winrm-password Insecure-Rattly-Rabbit-2022 --node-name $vmName -y


