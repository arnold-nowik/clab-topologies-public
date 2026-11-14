# 2026-07-08 02:26:11 by RouterOS 7.23.2
# system id = HBJlrwsi5/O
#
/interface bridge
add name=loopback
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
/routing ospf instance
add mpls-te-area=0.0.0.0 name=default router-id=5.5.5.5
/routing ospf area
add instance=default name=backbone
/ip address
add address=5.5.5.5 interface=loopback network=5.5.5.5
add address=10.4.5.5/24 interface=ether4 network=10.4.5.0
add address=10.3.5.5/24 interface=ether3 network=10.3.5.0
/ip dhcp-client
/mpls interface
add interface=ether3
add interface=ether4
/mpls ldp
add afi=ip lsr-id=5.5.5.5 transport-addresses=5.5.5.5
/mpls ldp interface
add interface=ether3
add interface=ether4
/mpls traffic-eng interface
add bandwidth=10Gbps interface=ether3
add bandwidth=10Gbps interface=ether4
/routing ospf interface-template
add area=backbone interfaces=loopback passive
add area=backbone interfaces=ether3,ether4
/system identity
set name=r5