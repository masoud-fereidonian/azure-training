# You can download azure-cli for windows and Linux from Microsoft website
# For Linux you can use apt yum ... package managers
# Install Azure CLI on MAC
brew update && brew install azure-cli

# login and set a subscription to be the current active subscription 
az login --subscription "<Name of your Subscription>"

# Make sure that the current subscription is selected 
az account list
az account set --subscription "<Name of your Subscription>"

# Create a Linux VM 
#1 First step is to create a resource group
az group create --Name "<Name Of Your resource group>" --location "<Azure Region Location>"

# you can also use the below command :
az group create -n "<Name Of Your resource group>" -l "<Azure Region Location>"

# Check your resource group 
az group list -o table

#2 Create virtual network (vnet) and subnet
az network create --resource-group "<Name Of Your resource group>" --Name "Name of your vnet" --address-prefix "Address space cidr" --subnetname "subnet name" --subnetprefix "cidr"

# Check the vnet 
az network vnet list -o table

#3 Create a public IP
az network public-ip create --resource-group "<Name Of Your resource group>" --name "Name of IP"

#4 Create Network Security Group
az network nsg create --resource-group "< resource group name > " --name "<Security group name>"

# Check the NSG
az network nsg list -o table
az network nsg list --output table --resource-group "< resource group name > "
az network nsg list --output table -g "< resource group name > "

#5 Create a virtula network interface and associate with public IP address
az network nic create --resource-group "" --name "" --vnet-name "" --subnet "" --network-Security-group "" --public-ip-address ""

#6 Create the VM
az vm create -resource-group "" --location "" --name "" --nics "" --image "" --admin-username "" --authentication-type "" --ssh-key-valu ~/.ssh/id_rsa.pub 

# General help  is --help or -h and you can use it with all form of commands 
az vm create --help

#7 Open SSH
az vm open-port -resource-group "" --name "<VM name>" --port "#"

# Get the public IP
az vm list-ip-addresses --name "<VM Name>"

# e.g
az login --subscription "<Subscription names>"
az account set -s "<Subscription names>"
az group create -n "test100-rg" -l "centralus"
az network vnet create -g "test100-rg" -n "test100-vnet" --address-prefix "192.168.0.0/16" --subnet-name "test100-subnet" --subnet-prefix "192.168.18.0/24"
az network public-ip create -g "test100-rg" -n "test100-public-ip"
az network nsg create -g "test100-rg" -n "test100-nsg"
az network nic create -g "test100-rg" --name "test100-nic" --vnet-name "test100-vnet" --subnet "test100-subnet" --network-security-group "test100-nsg" --public-ip-address "test100-public-ip"
az vm create -g "test100-rg" -l "centralus" -n "test100-vm" --nics "test100-nic" --image "rhel" --admin-username "masoud" --authentication-type "ssh" --ssh-key-value ~/.ssh/id_rsa.pub
az vm open-port -g "test100-rg" -n "test100-vm" --port "22"




# You can create a VM also fast , but keep in mind that its using most of the default settings and Azure will put it into our current vnet/subnet
az vm create --resource-group "" --name "" --image "" --admin-username "" --authentication-type "" --ssh-key-valu ~/.ssh/id_rsa.pub

# You need to open SSH
az vm open-port -g "<Resource group name>" -n "<VM name>" --port "22"

# And again you can get the IP by:
az vm list-ip-addresses --name "<VM Name>"

**************************************************************
# Create a Windows VM

#1 Creating the resource group we can use same resource group that we created for our Linux VM
az group create -n "test100-rg" -l "centralus"

#2 Creating vnet , and we also can use the same VM for our Linux machine
az network vnet create -g "test100-rg" -n "test100-vnet" --address-prefix "192.168.0.0/16" --subnet-name "test100-subnet" --subnet-prefix "192.168.18.0/24"  

#3 Create a public IP
az network public-ip create -g "test100-rg" -n "test100-public-ip"

#4 Creare a nsg 
az network nsg create -g "test100-rg" -n "test100-win-nsg"

#5 Create a nic card for the VM
az network nic create -g "test100-rg" -n "test100-nic" --vnet-name "test100-vnet" --subnet "test100-subnet" --network-security-group "test100-win-nsg" --public-ip-address "test100-public-ip"

#6 Create the VM
az vm create -g "test100-rg" -n "test100-vm" -l "centralus" --nics "test100-nic" --image "win2016datacenter" --admin-username "masoud" --admin-password "test$1234567890"

#7 open RDP in nsg 
az vm open-port --port "3389" -g "test100-rg" -n "test100-vm"

#8 get the Public IP address 
az vm list-ip-addresses --name "test100-vm" --output table