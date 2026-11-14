# 2026-07-11 12:49:29 by RouterOS 7.23.2
# system id = 3GWu0ZML5xE
#
/interface bridge
add name=br-cust-a protocol-mode=none
add name=br-cust-b protocol-mode=none
add name=lo0
add name=lo1
add name=lo2
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
set [ find default-name=ether6 ] disable-running-check=no
set [ find default-name=ether7 ] disable-running-check=no
set [ find default-name=ether8 ] disable-running-check=no
/ip vrf
add interfaces=ether6 name=CUST-C
/mpls traffic-eng path
add hops=10.1.4.4/strict,10.4.5.5/strict,10.3.5.3/strict name=long-path \
    record-route=yes
add hops=10.1.2.2/strict,10.2.3.3/strict name=short-path
/routing bgp instance
add as=65000 name=ibgp-l2vpn-te0 router-id=10.10.10.10
add as=65000 name=ibgp-l2vpn-te1 router-id=11.11.11.11
add as=65000 name=ibgp-l3vpn-long router-id=12.12.12.12
/routing bgp template
add as=65000 name=ibgp-l2vpn
add afi=vpnv4 as=65000 name=ibgp-l3vpn output.redistribute=\
    connected,static,bgp,vpn
/routing ospf instance
add mpls-te-area=0.0.0.0 name=default router-id=10.10.10.10
/routing ospf area
add instance=default name=backbone
/interface bridge port
add bridge=br-cust-a interface=ether8
add bridge=br-cust-b interface=ether7
/ip address
add address=10.10.10.10 interface=lo0 network=10.10.10.10
add address=11.11.11.11 interface=lo1 network=11.11.11.11
add address=12.12.12.12 interface=lo2 network=12.12.12.12
add address=10.1.2.1/24 interface=ether2 network=10.1.2.0
add address=10.1.4.1/24 interface=ether4 network=10.1.4.0
add address=192.168.35.1/24 interface=ether6 network=192.168.35.0
/ip dhcp-client
/ip route
add dst-address=34.34.34.34/32 gateway=10.1.4.4
/mpls interface
add interface=ether2
add interface=ether4
/mpls ldp
add afi=ip lsr-id=10.10.10.10 transport-addresses=10.10.10.10
/mpls ldp interface
add interface=ether2
add interface=ether4
/mpls traffic-eng interface
add bandwidth=10Gbps interface=ether2
add bandwidth=10Gbps interface=ether4
/mpls traffic-eng tunnel
add bandwidth=200Mbps name=te0 primary-path=short-path secondary-paths=\
    long-path to-address=30.30.30.30
add bandwidth=200Mbps name=te1 primary-path=long-path secondary-paths=\
    short-path to-address=33.33.33.33
/routing bgp connection
add afi=l2vpn input.filter=vpls-cust-b-in instance=ibgp-l2vpn-te0 \
    local.address=10.10.10.10 .role=ibgp name=vpls-te0 remote.address=\
    30.30.30.30 .as=65000 routing-table=main templates=ibgp-l2vpn
add afi=l2vpn input.filter=vpls-cust-a-in instance=ibgp-l2vpn-te1 \
    local.address=11.11.11.11 .role=ibgp name=vpls-te1 \
    remote.address=33.33.33.33 .as=65000 routing-table=main templates=\
    ibgp-l2vpn
add afi=vpnv4 input.filter=l3vpn-cust-c instance=ibgp-l3vpn-long \
    local.address=12.12.12.12 .role=ibgp name=l3vpn-long output.redistribute=\
    connected,static,bgp,vpn remote.address=34.34.34.34 .as=65000 \
    routing-table=main templates=ibgp-l3vpn
/routing bgp vpls
add bridge=br-cust-a export-route-targets=65010:10 import-route-targets=\
    65010:10 name=VPLS-CUST-A rd=65010:10 site-id=1
add bridge=br-cust-b export-route-targets=65020:20 import-route-targets=\
    65020:20 name=VPLS-CUST-B rd=65020:20 site-id=1
/routing bgp vpn
add export.redistribute=connected,static,bgp,vpn .route-targets=65030:30 \
    import.route-targets=65030:30 instance=ibgp-l3vpn-long \
    label-allocation-policy=per-vrf name=VPN-CUST-C route-distinguisher=\
    65030:35 vrf=CUST-C
/routing filter rule
add chain=vpls-cust-a-in rule=\
    "if (bgp-ext-communities includes rt:65010:10) { accept }"
add chain=vpls-cust-a-in rule=reject
add chain=vpls-cust-b-in rule=\
    "if (bgp-ext-communities includes rt:65020:20) { accept }"
add chain=vpls-cust-b-in rule=reject
add chain=l3vpn-cust-c rule=\
    "if ( bgp-ext-communities includes rt:65030:30) { accept } "
/routing ospf interface-template
add area=backbone interfaces=lo0,lo1,lo2 passive
add area=backbone interfaces=ether2,ether4
/system identity
set name=r1