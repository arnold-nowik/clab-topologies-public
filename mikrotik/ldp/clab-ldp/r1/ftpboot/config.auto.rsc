# 2026-07-06 02:58:20 by RouterOS 7.21.4
# system id = jVgQPf7aftG
#
/interface bridge
add name=loopback
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
/routing ospf instance
add name=default router-id=1.1.1.1
/routing ospf area
add instance=default name=backbone
/ip address
add address=1.1.1.1 interface=loopback network=1.1.1.1
add address=10.1.2.1/24 interface=ether2 network=10.1.2.0
/ip dhcp-client
/mpls interface
add interface=ether2
/mpls ldp
add afi=ip lsr-id=1.1.1.1 transport-addresses=1.1.1.1
/mpls ldp interface
add interface=ether2
/routing ospf interface-template
add area=backbone interfaces=loopback passive
add area=backbone interfaces=ether2
/system identity
set name=r1