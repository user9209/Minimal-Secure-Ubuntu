#!/bin/bash
apt install -y firefox chromium-browser clamtk
apt purge avahi-daemon

apt install -y nftables
systemctl enable nftables.service

# enable nftables
update-alternatives --set iptables /usr/sbin/iptables-nft
update-alternatives --set ip6tables /usr/sbin/ip6tables-nft
update-alternatives --set arptables /usr/sbin/arptables-nft
update-alternatives --set ebtables /usr/sbin/ebtables-nft


cat > /etc/nftables.conf <<- EOM
#!/usr/sbin/nft -f
# reload / restart firewall
#   systemctl restart nftables.service
# any drops?
#   cat /var/log/syslog | grep 'nft-fw.dropped'
flush ruleset

table inet filter {
        chain input {
                type filter hook input priority 0; policy drop;
                ct state invalid counter drop comment "early drop of invalid packets"

                # allow any localhost traffic
                iif lo accept

                # disable ping command
                ip protocol icmp icmp type {echo-request} reject with icmp type host-unreachable

                # allow / disable igmp command
                #ip protocol igmp reject with icmpx type admin-prohibited comment "Reject IGMP"
                ip protocol igmp accept comment "Accept IGMP"

                # drop spoofen localhost traffic
                iif != lo ip daddr 127.0.0.1/8 counter drop comment "drop connections to loopback not coming from loopback"
                iif != lo ip6 daddr ::1/128 counter drop comment "drop connections to loopback not coming from loopback"

                # accept neighbour discovery otherwise connectivity breaks
                ip6 nexthdr icmpv6 icmpv6 type { nd-neighbor-solicit, echo-request, nd-router-advert, nd-neighbor-advert, nd-router-solicit, mld-listener-query } limit rate 10/second accept

                # allow open connections
                ct state { established, related } accept

                ## allow others here
                tcp dport {22} ct state new,established limit rate 3/second accept

                # count and drop any other traffic
                counter log prefix "nft-fw.dropped.input " reject with icmpx type admin-prohibited comment "count dropped packets"
        }
        chain forward {
                type filter hook forward priority 0; policy drop;
                # allow any localhost traffic
                iif lo accept
        }
        chain output {
                type filter hook output priority 0; policy drop;
                # allow any localhost traffic
                iif lo accept

                ip protocol icmp icmp type {echo-request} accept

                # accept neighbour discovery otherwise connectivity breaks
                ip6 nexthdr icmpv6 icmpv6 type { nd-neighbor-solicit, echo-request, nd-router-advert, nd-neighbor-advert, nd-router-solicit, mld-listener-query } accept

                ip protocol igmp accept comment "Accept IGMP"

                # allow open connections
                ct state { established, related } accept

                udp dport {53, 67, 68, 123, 443} ct state new,established accept
                tcp dport {53, 80, 123, 443} ct state new,established accept
        }
}
EOM
