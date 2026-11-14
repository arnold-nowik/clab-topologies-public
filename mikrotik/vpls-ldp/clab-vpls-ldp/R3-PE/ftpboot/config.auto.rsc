# 2026-07-06 04:12:10 by RouterOS 7.21.4
# system id = l0AMDJCa1mE
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
add disabled=no mac-address=02:37:39:A7:B8:A7 name=pw-cust-a peer=1.1.1.1 \
    vpls-id=65000:100
/routing ospf instance
add name=default router-id=3.3.3.3
/routing ospf area
add instance=default name=backbone
/interface bridge port
add bridge=br-cust-a interface=ether8
add bridge=br-cust-a interface=pw-cust-a
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