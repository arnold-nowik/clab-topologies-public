# 2026-07-08 02:26:11 by RouterOS 7.23.2
# system id = 758wX6cue3I
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
set [ find default-name=ether6 ] disable-running-check=no
set [ find default-name=ether7 ] disable-running-check=no
set [ find default-name=ether8 ] disable-running-check=no
/ip address
add address=192.168.100.1/24 interface=ether8 network=192.168.100.0
/ip dhcp-client
/system identity
set name=CE1