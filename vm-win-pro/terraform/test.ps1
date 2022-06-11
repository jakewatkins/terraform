
#get password from the keyvault
$secret = (ConvertFrom-Json -InputObject ((az keyvault secret show --name SprintPassword --vault-name  kvGPSecrets) -join " ")).value

#setup remote session
$username = '.\sysadmin'
$password = ConvertTo-SecureString -string $secret -AsPlainText -Force

$credential = new-object -TypeName system.management.automation.pscredential -ArgumentList ($username, $password)

$session = new-pssession -computer vm-jkw-ws-sprinter.centralus.cloudapp.azure.com -Credential $credential

invoke-command -session $session -filepath ./files/config.ps1

exit-pssession 