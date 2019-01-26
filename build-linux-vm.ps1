
Connect-AzureRmAccount -Subscription " "
Get-AzureRmResourceGroup -Location "centralus"
New-AzureRmResourceGroup -Name " itrepo-rg" -Location "centralus"
$rg = Get-AzureRmResourceGroup -Name " itrepo-rg" -location "centralus"

$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig `
    -Name ' itrepo-subnet' `
    -AddressPrefix '192.168.19.0/24'

$subnetConfig


$vnet = New-AzureRmVirtualNetwork `
    -ResourceGroupName $rg.ResourceGroupName `
    -Location $rg.Location `
    -Name ' itrepo-vnet' `
    -AddressPrefix '192.168.0.0/16' `
    -Subnet $subnetConfig

$vnet

$pip = New-AzureRmPublicIpAddress `
    -ResourceGroupName $rg.ResourceGroupName `
    -Location $rg.Location `
    -Name ' itrepo-linux-2-pip-1' `
    -AllocationMethod Static

$pip

$rule1 = New-AzureRmNetworkSecurityRuleConfig `
    -Name ssh-rule `
    -Description 'Allow SSH' `
    -Access Allow `
    -Protocol Tcp `
    -Direction Inbound `
    -Priority 100 `
    -SourceAddressPrefix Internet `
    -SourcePortRange * `
    -DestinationAddressPrefix * `
    -DestinationPortRange 22

$rule1

$nsg = New-AzureRmNetworkSecurityGroup `
    -ResourceGroupName $rg.ResourceGroupName `
    -Location $rg.Location `
    -Name 'psdemo-linux-nsg-2' `
    -SecurityRules $rule1

    
$nsg | more

$subnet = $vnet.Subnets | Where-Object { $_.Name -eq " itrepo-subnet"} 

$nic = New-AzureRmNetworkInterface `
    -ResourceGroupName $rg.ResourceGroupName `
    -Location $rg.Location `
    -Name 'psdemo-linux-2-nic-1' `
    -Subnet $subnet `
    -PublicIpAddress $pip `
    -NetworkSecurityGroup $nsg


$LinuxVmConfig = New-AzureRmVMConfig `
-VMName 'psdemo-linux-2' `
-VMSize 'Standard_D1'


$password = ConvertTo-SecureString 'test$1234567890' -AsPlainText -Force
$LinuxCred = New-Object System.Management.Automation.PSCredential ('masoud', $password)




$LinuxVmConfig = Set-AzureRmVMOperatingSystem `
    -VM $LinuxVmConfig `
    -Linux `
    -ComputerName 'psdemo-linux-2' `
    -DisablePasswordAuthentication `
    -Credential $LinuxCred
   

$sshPublicKey = Get-Content "~\.ssh\id_rsa.pub"
Add-AzureRmVMSshPublicKey `
    -VM $LinuxVmConfig `
    -KeyData $sshPublicKey `
    -Path "/home/masoud/.ssh/authorized_keys"


Get-AzureRmVMImageSku -Location $rg.Location -PublisherName "Redhat" -Offer "rhel"


$LinuxVmConfig = Set-AzureRmVMSourceImage `
    -VM $LinuxVmConfig `
    -PublisherName 'Redhat' `
    -Offer 'rhel' `
    -Skus '7.4' `
    -Version 'latest' 

$LinuxVmConfig = Add-AzureRmVMNetworkInterface `
    -VM $LinuxVmConfig `
    -Id $nic.Id 


New-AzureRmVM `
    -ResourceGroupName $rg.ResourceGroupName `
    -Location $rg.Location `
    -VM $LinuxVmConfig

$MyIP = Get-AzureRmPublicIpAddress `
    -ResourceGroupName $rg.ResourceGroupName `
    -Name $pip.Name | Select-Object -ExpandProperty IpAddress

ssh -l masoud $MyIP
