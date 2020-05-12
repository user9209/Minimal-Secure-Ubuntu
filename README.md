# Minimal-Secure-Ubuntu
Goal is to provide a minimal ubuntu installation as a secure environment.



## Using for
- Virus Scan (requires live cd!)
- Online Banking (Browser and Virus-Scanner)




## Features
- Firewall (no forwarding or incoming connections)
- Anti-Virus
- Browser with Adblock
- Disk-Encryption (LUKS, Veracrypt)
- Remote Support (AnyDesk *, SSH, Wireguard *)
- Partition operations (gparted)
- Network file access (Samba)

*) not implemented yet



## May
- Only whitelist online banking sites



## Requirements

### Online Banking

- Anti-Virus-Scanner
- using HTTPS
- well known pages
- WPA 2+
- Strong passwords -> Password-Generator
- Clean Browser Sessions
- block all other content

### Anti-Virus

- Anti-Virus-Scanner
- Update Virus-Database





## Firewall incoming

- only established valid connections
- may allow ssh



## Firewall outgoing

- HTTPS (80/t,443/t) mit QUIC (443/u)
- DNS (53/b)
- NTP (123/b)
- DHCP (67/u, 68/u)
- IPv6 - DHCP and others
- [SMTP, IMAP, POP3]
- [Samba: 137/b, 138/u, 139/t]
- [SSH (22/t), RTP (3389/b)]
- [WPA 2+]



## Blocked by firewall

- mDNS (5353/u)

- git-ssh (22/t)