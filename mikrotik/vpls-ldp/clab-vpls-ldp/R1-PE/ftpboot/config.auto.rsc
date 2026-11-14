# 2026-07-06 04:12:10 by RouterOS 7.21.4
# system id = wYzZ8neVjBN
#
/interface bridge
add name=br-cust-a protocol-mode=none
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
/interface vpls
add mac-address=02:27:79:98:D2:B3 name=pw-cust-a peer=3.3.3.3 vpls-id=\
    65000:100
/routing ospf instance
add name=default router-id=1.1.1.1
/routing ospf area
add instance=default name=backbone
/interface bridge port
add bridge=br-cust-a interface=ether8
add bridge=br-cust-a interface=pw-cust-a
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