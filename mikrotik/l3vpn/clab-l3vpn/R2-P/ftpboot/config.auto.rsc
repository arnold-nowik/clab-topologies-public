# 2026-07-08 02:26:11 by RouterOS 7.23.2
# system id = rbaH+iniqPI
#
/interface bridge
add name=loopback
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
set [ find default-name=ether6 ] disable-running-check=no
set [ find default-name=ether7 ] disable-running-check=no
set [ find default-name=ether8 ] disable-running-check=no
set [ find default-name=ether9 ] disable-running-check=no
set [ find default-name=ether10 ] disable-running-check=no
/routing ospf instance
add mpls-te-area=0.0.0.0 name=default router-id=2.2.2.2
/routing ospf area
add instance=default name=backbone
/ip address
add address=2.2.2.2 interface=loopback network=2.2.2.2
add address=10.1.2.2/24 interface=ether10 network=10.1.2.0
add address=10.2.3.2/24 interface=ether3 network=10.2.3.0
/ip dhcp-client
/mpls interface
add interface=ether10
add interface=ether3
/mpls ldp
add afi=ip lsr-id=2.2.2.2 transport-addresses=2.2.2.2
/mpls ldp interface
add interface=ether10
add interface=ether3
/mpls traffic-eng interface
add bandwidth=10Gbps interface=ether10
add bandwidth=10Gbps interface=ether3
/routing ospf interface-template
add area=backbone interfaces=loopback passive
add area=backbone interfaces=ether10,ether3
/system identity
set name=r2