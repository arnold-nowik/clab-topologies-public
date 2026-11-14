# 2026-07-08 02:26:11 by RouterOS 7.23.2
# system id = TTwOFweJ2OA
#
/interface bridge
add name=br-cust-a protocol-mode=none
add name=br-cust-b protocol-mode=none
add name=lo0
add name=lo1
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
set [ find default-name=ether6 ] disable-running-check=no
set [ find default-name=ether7 ] disable-running-check=no
set [ find default-name=ether8 ] disable-running-check=no
/mpls traffic-eng path
add hops=10.1.4.4/strict,10.4.5.5/strict,10.3.5.3/strict name=long-path \
    record-route=yes
add hops=10.1.2.2/strict,10.2.3.3/strict name=short-path
/routing bgp instance
add as=65000 name=ibgp-l2vpn-te0 router-id=1.1.1.1
add as=65000 name=ibgp-l2vpn-te1 router-id=11.11.11.11
/routing bgp template
add as=65000 name=ibgp-l2vpn
/routing ospf instance
add mpls-te-area=0.0.0.0 name=default router-id=1.1.1.1
/routing ospf area
add instance=default name=backbone
/interface bridge port
add bridge=br-cust-a interface=ether8
add bridge=br-cust-b interface=ether7
/ip address
add address=1.1.1.1 interface=lo0 network=1.1.1.1
add address=11.11.11.11 interface=lo1 network=11.11.11.11
add address=10.1.2.1/24 interface=ether2 network=10.1.2.0
add address=10.1.4.1/24 interface=ether4 network=10.1.4.0
/ip dhcp-client
/mpls interface
add interface=ether2
add interface=ether4
/mpls traffic-eng interface
add bandwidth=10Gbps interface=ether2
add bandwidth=10Gbps interface=ether4
/mpls traffic-eng tunnel
add bandwidth=200Mbps name=te0 primary-path=short-path secondary-paths=\
    long-path to-address=3.3.3.3
add bandwidth=200Mbps name=te1 primary-path=long-path secondary-paths=\
    short-path to-address=33.33.33.33
/routing bgp connection
add afi=l2vpn input.filter=vpls-cust-b-in instance=ibgp-l2vpn-te0 \
    local.address=1.1.1.1 .role=ibgp name=bgp-connection-te0 remote.address=\
    3.3.3.3 .as=65000 routing-table=main templates=ibgp-l2vpn
add afi=l2vpn input.filter=vpls-cust-a-in instance=ibgp-l2vpn-te1 \
    local.address=11.11.11.11 .role=ibgp name=bgp-connection-te1 \
    remote.address=33.33.33.33 .as=65000 routing-table=main templates=\
    ibgp-l2vpn
/routing bgp vpls
add bridge=br-cust-a export-route-targets=65100:100 import-route-targets=\
    65100:100 name=bgp-cust-a rd=65100:100 site-id=1
add bridge=br-cust-b export-route-targets=65200:200 import-route-targets=\
    65200:200 name=bgp-cust-b rd=65200:200 site-id=1
/routing filter rule
add chain=vpls-cust-a-in rule=\
    "if (bgp-ext-communities includes rt:65100:100) { accept }"
add chain=vpls-cust-a-in rule=reject
add chain=vpls-cust-b-in rule=\
    "if (bgp-ext-communities includes rt:65200:200) { accept }"
add chain=vpls-cust-b-in rule=reject
/routing ospf interface-template
add area=backbone interfaces=lo0,lo1 passive
add area=backbone interfaces=ether2,ether4
/system identity
set name=r1