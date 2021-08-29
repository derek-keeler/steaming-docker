if (( Get-Service -Name "Windows Defender Firewall").Status -eq "Running") {

    # Protocol:Port to open in the Windows Firewall
    $ProtocolsAndPorts = @{
        "TCP"=@(27015);
        "UDP"=@(27015, 33540)
    }

    # Set all inbound ports & protocols to 'allow'
    $ProtocolsAndPorts.Keys | ForEach-Object {
        $protocol = $PSItem
        $ProtocolsAndPorts[$protocol] | ForEach-Object {
            $port = $PSItem
            New-NetFirewallRule -DisplayName "Wreckfest Dedicated Server $protocol $port" -Direction inbound -Profile Any -Action Allow -LocalPort $port -Protocol $protocol
        }
    }
}