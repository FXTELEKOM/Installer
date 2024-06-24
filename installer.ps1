$logo = @"
  ________   _________ ______ _      ______ _  ______  __  __ 
 |  ____\ \ / /__   __|  ____| |    |  ____| |/ / __ \|  \/  |
 | |__   \ V /   | |  | |__  | |    | |__  | ' / |  | | \  / |
 |  __|   > <    | |  |  __| | |    |  __| |  <| |  | | |\/| |
 | |     / . \   | |  | |____| |____| |____| . \ |__| | |  | |
 |_|    /_/ \_\  |_|  |______|______|______|_|\_\____/|_|  |_|
                                                              
                                                              
"@

Write-Host "$logo"

Write-Host "This script sets the DNS server of FXTELEKOM on every active real network interface. (WiFi/Ethernet)`n"

$allNICs = Get-NetAdapter

# Filter active physical NICs
$activeNICs = @($allNICs | Where-Object { 
    $_.Status -eq 'Up' -and ($_.PhysicalMediaType -eq '802.3' -or $_.PhysicalMediaType -eq 'Native 802.11')
})

Write-Host "Active network interfaces:"
$activeNICs | Format-Table -Property Name, Status, PhysicalMediaType, InterfaceDescription

if ($activeNICs.Count -gt 0) {
    foreach ($nic in $activeNICs) {
        Write-Host "Setting DNS: $($nic.Name)"

        # Set the IPv4 DNS server
        Set-DnsClientServerAddress -InterfaceAlias $nic.Name -ServerAddresses "193.188.192.47", "9.9.9.9"

        # Set the IPv6 DNS server
        Set-DnsClientServerAddress -InterfaceAlias $nic.Name -ServerAddresses "2a09:7ac0::1:2d4b:2dc2", "2620:fe::fe"

        Write-Host "DNS set successfully: $($nic.Name)"
    }
} else {
    Write-Host "Active network interface not found!"
}
