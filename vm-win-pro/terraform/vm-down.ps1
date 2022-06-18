#
#
#
#
param($vmName)

# get the local machine's ip address
$workstationId = (Invoke-webrequest ifconfig.me/ip).Content.Trim()

write-host "deleting $vmName from Chef server"
knife node delete $vmName -y

write-host "removing $vmName from Azure"
terraform destroy -var="workstation_ip=$workstationId"  -var="machineName=$vmName" -auto-approve