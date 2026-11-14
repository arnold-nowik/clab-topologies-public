# RouterOS 7.23.2
# CE5 - Customer C site 1
# LAN: 192.168.35.0/24
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
set [ find default-name=ether6 ] disable-running-check=no
/ip address
add address=192.168.35.5/24 interface=ether6 network=192.168.35.0
/ip route
add dst-address=192.168.36.0/24 gateway=192.168.35.1
/ip dhcp-client
/system identity
set name=CE5-cust-c
