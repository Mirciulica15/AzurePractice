param (
    [parameter (mandatory = $true)]
    [string] $newVmSize
)

$resourceGroupName = "my-automated-vm_group"
$vmName = "my-automated-vm"

Connect-AzAccount -Identity

$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName

if ($vm -eq $null) {
    Write-Output "The VM with name '$vmName' in resource group '$resourceGroupName' does not exist."
} else {
    $vm.HardwareProfile.VmSize = $newVmSize
    Update-AzVM -VM $vm -ResourceGroupName $resourceGroupName
    Write-Output "VM '$vmName' in resource group '$resourceGroupName' has been resized to '$newVmSize'."
}

Disconnect-AzAccount
