param (
    [parameter (mandatory = $true)]
    [string] $newVmSize
)

$resourceGroupName = "my-automated-vm_group"
$vmName = "my-automated-vm"

$clientId = $env:AZURE_CLIENT_ID
$clientSecret = $env:AZURE_CLIENT_SECRET
$tenantId = $env:AZURE_TENANT_ID
$subscriptionId = $env:AZURE_SUBSCRIPTION_ID
$secpasswd = ConvertTo-SecureString $clientSecret -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($clientId, $secpasswd)
Connect-AzAccount -ServicePrincipal -Tenant $tenantId -Credential $credential -Subscription $subscriptionId

$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName

if ($vm -eq $null) {
    Write-Output "The VM with name '$vmName' in resource group '$resourceGroupName' does not exist."
} else {
    $vm.HardwareProfile.VmSize = $newVmSize
    Update-AzVM -VM $vm -ResourceGroupName $resourceGroupName
    Write-Output "VM '$vmName' in resource group '$resourceGroupName' has been resized to '$newVmSize'."
}

Disconnect-AzAccount
