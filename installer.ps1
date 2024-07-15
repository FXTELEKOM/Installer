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
        Set-DnsClientServerAddress -InterfaceAlias $nic.Name -ServerAddresses "152.53.2.112", "152.53.0.180"

        # Set the IPv6 DNS server
        Set-DnsClientServerAddress -InterfaceAlias $nic.Name -ServerAddresses "2a0a:4cc0:0:12b8::b00b:babe", "2a0a:4cc0:0:1203::dead:beef"

        Write-Host "DNS set successfully: $($nic.Name)"
    }
} else {
    Write-Host "Active network interface not found!"
}
