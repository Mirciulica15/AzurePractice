param (
    [parameter (mandatory = $true)]
    [string] $newVmSize
)

$resourceGroupName = $env:RESOURCE_GROUP_NAME
$vmName = $env:VM_NAME

$clientId = $env:AZURE_CLIENT_ID
$clientSecret = $env:AZURE_CLIENT_SECRET
$tenantId = $env:AZURE_TENANT_ID
$subscriptionId = $env:AZURE_SUBSCRIPTION_ID

$secpasswd = ConvertTo-SecureString $clientSecret -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($clientId, $secpasswd)
Connect-AzAccount -ServicePrincipal -Tenant $tenantId -Credential $credential -Subscription $subscriptionId

try {
    $vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName -ErrorAction Stop

    # If the VM exists, update its size
    $vm.HardwareProfile.VmSize = $newVmSize
    Update-AzVM -VM $vm -ResourceGroupName $resourceGroupName
    Write-Output "VM '$vmName' in resource group '$resourceGroupName' has been resized to '$newVmSize'."
} catch {
    if ($_.Exception.Message -like "*not found*") {
        Write-Output "The VM with name '$vmName' in resource group '$resourceGroupName' does not exist."
    } else {
        Write-Output "An error occurred: $($_.Exception.Message)"
    }
}

Disconnect-AzAccount
