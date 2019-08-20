# Read Name, Network, vLAN ID from CSV
# Please Create a CSV in Following Format
# OS_SPEC,IP_ADDR,NETMASK,GATEWAY,V_CLUSTER,TEMPLATE,D_CLUSTER,VM_NAME,VLAN,MEMORY,DISK_SIZE,VCPU
# By Syed Bilal Masaud
# Email : chillchamp878@gmail.com

    foreach ($Row in (import-csv C:\Users\syed-bilal.masaud\Documents\vm-first.csv)) {
    $OS_SPEC = $Row.OS_SPEC
    $IP_ADDR = $Row.IP_ADDR
    $NETMASK = $Row.NETMASK
	$GATEWAY = $Row.GATEWAY
	$V_CLUSTER = $Row.V_CLUSTER
	$VMTEMPLATE = $Row.TEMPLATE
	$D_CLUSTER = $Row.D_CLUSTER
	$VM_NAME = $Row.VM_NAME
	$VLAN = $Row.VLAN
	$MEMORY = $Row.MEMORY
	$DISK_SIZE = $Row.DISK_SIZE
	$CPU = $Row.VCPU
Get-OSCustomizationNicMapping -OSCustomizationSpec $OS_SPEC | Set-OSCustomizationNicMapping -IPMode 'UseStaticIP' -IPAddress $IP_ADDR -SubnetMask $NETMASK -DefaultGateway $GATEWAY 
$OSSpec=Get-OSCustomizationSpec -Name $OS_SPEC
$CLUSTER = $V_CLUSTER
$Template=Get-Template -Name $VMTEMPLATE
$DSCLUSTER=Get-DatastoreCluster -Name $D_CLUSTER
$VMHOST= Get-Cluster $CLUSTER | Get-VMHost | Get-Random
New-VM -Name $VM_NAME -Template $Template -VMHost $VMHOST -Datastore $DSCLUSTER -OSCustomizationSpec $OSSpec
$VLAN=Get-VDPortgroup -Name $VLAN
$OVLAN = Get-VM -Name $VM_NAME| Get-NetworkAdapter -Name "Network adapter 1"
Set-NetworkAdapter -NetworkAdapter $OVLAN -Portgroup $VLAN –Confirm:$false
Get-VM -Name $VM_NAME | Set-VM -MemoryGB $MEMORY -Confirm:$false
Get-HardDisk -vm $VM_NAME | where {$_.Name -eq 'Hard Disk 1'} | Set-HardDisk -CapacityGB $DISK_SIZE -Confirm:$false
Get-VM -name $VM_NAME | set-VM -NumCpu $CPU -Confirm:$false
# Disconnect from vcenter
   # Disconnect-viserver $vcenter -Confirm:$false
    }