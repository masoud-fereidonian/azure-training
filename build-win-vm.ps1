$password = ConvertTo-SecureString 'test$1234567890' -AsPlainText -Force
$WindowsCred = New-Object System.Management.Automation.PSCredential ('masoud', $password)



$vmParams = @{
    ResourceGroupName = ' itrepo-rg'
    Name = ' itrepo-win-2'
    Location = 'centralus'
    Size = 'Standard_D1'
    Image = 'Win2016Datacenter'
    PublicIpAddressName = ' itrepo-win-2-pip-1'
    Credential = $WindowsCred
    VirtualNetworkName = ' itrepo-vnet-2'
    SubnetName = ' itrepo-subnet'
    SecurityGroupName = ' itrepo-win-nsg-2'
    OpenPorts = 3389
}

New-AzureRmVM @vmParams 


Get-AzureRmPublicIpAddress `
    -ResourceGroupName ' itrepo-rg' `
    -Name ' itrepo-win-2-pip-1' | Select-Object -ExpandProperty IpAddress