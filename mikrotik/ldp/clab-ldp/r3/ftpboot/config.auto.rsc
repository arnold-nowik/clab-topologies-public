# 2026-07-06 02:58:20 by RouterOS 7.21.4
# system id = WmxedVjwVkB
#
/interface bridge
add name=loopback
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
/routing ospf instance
add name=default router-id=3.3.3.3
/routing ospf area
add instance=default name=backbone
/ip address
add address=10.2.3.3/24 interface=ether3 network=10.2.3.0
add address=3.3.3.3 interface=loopback network=3.3.3.3
/ip dhcp-client
/mpls interface
add interface=ether3
/mpls ldp
add afi=ip lsr-id=3.3.3.3 transport-addresses=3.3.3.3
/mpls ldp interface
add interface=ether3
/routing ospf interface-template
add area=backbone interfaces=loopback passive
add area=backbone interfaces=ether3
/system identity
set name=r3