# 2026-07-11 12:47:19 by RouterOS 7.23.2
# system id = NT9Y9IyfX0H
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
add hops=10.3.5.5/strict,10.4.5.4/strict,10.1.4.1/strict name=long-path \
    record-route=yes
add hops=10.2.3.2/strict,10.1.2.1/strict name=short-path
/routing bgp instance
add as=65000 name=ibgp-l2vpn-te0 router-id=30.30.30.30
add as=65000 name=ibgp-l2vpn-te1 router-id=33.33.33.33
add as=65000 name=ibgp-l3vpn-long router-id=34.34.34.34
/routing bgp template
add as=65000 name=ibgp-l2vpn
add afi=vpnv4 as=65000 name=ibgp-l3vpn output.redistribute=\
    connected,static,bgp,vpn
/routing ospf instance
add mpls-te-area=0.0.0.0 name=default router-id=30.30.30.30
/routing ospf area
add instance=default name=backbone
/interface bridge port
add bridge=br-cust-a interface=ether8
add bridge=br-cust-b interface=ether7
/ip address
add address=30.30.30.30 interface=lo0 network=30.30.30.30
add address=33.33.33.33 interface=lo1 network=33.33.33.33
add address=34.34.34.34 interface=lo2 network=34.34.34.34
add address=10.2.3.3/24 interface=ether2 network=10.2.3.0
add address=10.3.5.3/24 interface=ether5 network=10.3.5.0
add address=192.168.36.1/24 interface=ether6 network=192.168.36.0
/ip dhcp-client
/ip route
add dst-address=12.12.12.12/32 gateway=10.3.5.5
/mpls interface
add interface=ether2
add interface=ether5
/mpls ldp
add afi=ip lsr-id=30.30.30.30 transport-addresses=30.30.30.30
/mpls ldp interface
add interface=ether2
add interface=ether5
/mpls traffic-eng interface
add bandwidth=10Gbps interface=ether2
add bandwidth=10Gbps interface=ether5
/mpls traffic-eng tunnel
add bandwidth=200Mbps name=te0 primary-path=short-path secondary-paths=\
    long-path to-address=10.10.10.10
add bandwidth=200Mbps name=te1 primary-path=long-path secondary-paths=\
    short-path to-address=11.11.11.11
/routing bgp connection
add afi=l2vpn input.filter=vpls-cust-b-in instance=ibgp-l2vpn-te0 \
    local.address=30.30.30.30 .role=ibgp name=vpls-te0 remote.address=\
    10.10.10.10 .as=65000 routing-table=main templates=ibgp-l2vpn
add afi=l2vpn input.filter=vpls-cust-a-in instance=ibgp-l2vpn-te1 \
    local.address=33.33.33.33 .role=ibgp name=vpls-te1 \
    remote.address=11.11.11.11 .as=65000 routing-table=main templates=\
    ibgp-l2vpn
add afi=vpnv4 input.filter=l3vpn-cust-c instance=ibgp-l3vpn-long \
    local.address=34.34.34.34 .role=ibgp name=l3vpn-long output.redistribute=\
    connected,static,bgp,vpn remote.address=12.12.12.12 .as=65000 \
    routing-table=main templates=ibgp-l3vpn
/routing bgp vpls
add bridge=br-cust-a export-route-targets=65010:10 import-route-targets=\
    65010:10 name=VPLS-CUST-A rd=65010:10 site-id=3
add bridge=br-cust-b export-route-targets=65020:20 import-route-targets=\
    65020:20 name=VPLS-CUST-B rd=65020:20 site-id=3
/routing bgp vpn
add export.redistribute=connected,static,bgp,vpn .route-targets=65030:30 \
    import.route-targets=65030:30 instance=ibgp-l3vpn-long \
    label-allocation-policy=per-vrf name=VPN-CUST-C route-distinguisher=\
    65030:36 vrf=CUST-C
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
add area=backbone interfaces=ether2,ether5
/system identity
set name=r3