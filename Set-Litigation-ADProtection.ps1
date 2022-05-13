#######################################################
# This script will prompt you for a mailbox, then 
# set Litigation Hold, change AD description,
# and set AD deletion protection on account
#
# Run Set-Litigation-ADProtection.ps1 in the EMS
#
# Stacey Branham
#
# 2021
#######################################################
$name = Read-Host "Enter a username"

##Append legal hold disclaimer to AD Description Field

Get-ADUser "$name" -Properties Description | ForEach-Object {Set-ADUser $_ -Description "$($_.Description) - Do Not Delete - Legal Hold"}

##Enable accidental deletion protection on account

Get-ADUser "$name" | ForEach-Object {Set-ADObject -Identity $_ -protectedFromAccidentalDeletion $True}

##Enable Litigation Hold on Mailbox

Set-Mailbox "$name" -LitigationHoldEnabled $true

Start-Sleep -s 30

##Checking Our Work

Get-Mailbox "$name" | FL Name,LitigationHoldEnabled,@{N='Description';E={(Get-ADUser $_.Name -properties description).Description}},@{N='Protected';E={(Get-ADUser $_.Name -properties *).ProtectedFromAccidentalDeletion}}

Write-Host "All Done, check the above settings! `n`n" -ForegroundColor Green