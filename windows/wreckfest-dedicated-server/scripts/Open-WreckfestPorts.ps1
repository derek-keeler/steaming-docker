<#
.Synopsis
Opens the necessary ports for the Wreckfest Dedicated game server.

.PARAMETER ProtocolsAndPorts
Dictionary of protocols to port lists. The dictionary should be specified in PS syntax such as @{"PROTOCOL"=@(123,124,125);"PROTOCOL_2"=@(123)}.

.EXAMPLE
Open-WreckfestPorts -Verbose
Open the default ports and write verbose logging information.

.EXAMPLE
Open-WreckfestPorts -ProtocolsAndPorts @{"TCP"=@(123,234);"UDP"=@(234,245,3455)}
Open the specific ports set on the command line only, ignoring the default ports.
#>

[CmdletBinding()]
Param(
    # Dictionary of Protocol[str]:Ports[array of uint]
    [Parameter()]
    [Object]
    $ProtocolsAndPorts = @{
        "TCP"=@(27015);
        "UDP"=@(27015, 33540)
    }
)

Write-Verbose "Setting ports to be accessible"
Write-Verbose "$ProtocolsAndPorts"

if (( Get-Service -Name "Windows Defender Firewall").Status -ne "Running") {
    Write-Verbose "No firewall running. No need to set ports."
} else {
    Write-Verbose "Windows firewall is running, setting ports..."
    # Protocol:Port to open in the Windows Firewall

    # Set all inbound ports & protocols to 'allow'
    $ProtocolsAndPorts.Keys | ForEach-Object {
        $protocol = $PSItem
        Write-Verbose "==] Opening $protocol ports..."
        $ProtocolsAndPorts[$protocol] | ForEach-Object {
            $port = $PSItem
            Write-Verbose "====] Opening port $port"
            New-NetFirewallRule -DisplayName "Wreckfest Dedicated Server $protocol $port" -Direction inbound -Profile Any -Action Allow -LocalPort $port -Protocol $protocol
        }
    }
}