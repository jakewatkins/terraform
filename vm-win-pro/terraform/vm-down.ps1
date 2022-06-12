# get the local machine's ip address
$workstationId = (Invoke-webrequest ifconfig.me/ip).Content.Trim()

terraform destroy -var="workstation_ip=$workstationId" -auto-approve