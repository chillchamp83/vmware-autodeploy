# PowerCLI Script for adding vmdk to VM and extending disk in windows
# Author : Syed Bilal Masaud
# Email : chillchamp878@gmail.com
# you can add this script to existing 

param(
  [string]$VM
)
$VM = Get-VM $VM
Get-VM $VM | Get-HardDisk | FT Parent, Name, CapacityGB -Autosize
$HardDisk = Read-Host "Enter VMware Hard Disk (Ex. 1)"
$HardDisk = "Hard Disk " + $HardDisk
$HardDiskSize = Read-Host "Enter the new Hard Disk size in GB (Ex. 100)"
$VolumeLetter = Read-Host "Enter the volume letter (Ex. c,d,e,f)"
Get-HardDisk -vm $VM | where {$_.Name -eq $HardDisk} | Set-HardDisk -CapacityGB $HardDiskSize -Confirm:$false
Invoke-VMScript -vm $VM -ScriptText "echo rescan > c:\diskpart.txt && echo select vol $VolumeLetter >> c:\diskpart.txt && echo extend >> c:\diskpartsummary.txt && diskpart.exe /s c:\diskpartsummary.txt" -ScriptType BAT