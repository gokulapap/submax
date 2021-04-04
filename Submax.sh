#!/bin/bash

PURPLE='\033[1;30m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PINK='\033[1;35m'
LBLUE='\033[1;36m'
WHITE='\033[1;37m'


printf "\n${YELLOW}[*] Installing Requirements..please wait !\n"
apt install toilet &> /dev/null

toilet -f slant -F gay submax

printf "\n${WHITE}[!] Enter domain to Enumerate subdomains : "
read -r url

printf "${BLUE}\n[*] Subdomain Enumeration started!\n"

printf "${GREEN}\n[+] Enumerating subdomains from subfinder .."
subfinder -d $url -silent > sub1
printf "${GREEN}\n[+] Enumerating subdomains from assetfinder .."
assetfinder $url > sub2

printf "${GREEN}\n[+] Enumerating subdomains from crt.sh .."
curl -s "https://crt.sh/?q=$url" | grep "<TD>" | grep $url | cut -d ">" -f2 | cut -d "<" -f1 | sort -u | sed '/^*/d' > sub3
printf "${GREEN}\n[+] Enumerating subdomains from rapiddns .."
curl -s "https://rapiddns.io/subdomain/$url#result" | grep "<td><a" | cut -d '"' -f 2 | grep http | cut -d '/' -f3 | sort -u > sub4
printf "${GREEN}\n[+] Enumerating subdomains from bufferover .."
curl -s "https://dns.bufferover.run/dns?q=.$url" | jq -r .FDNS_A[] | cut -d '\' -f2 | cut -d "," -f2 |  sort -u > sub5
printf "${GREEN}\n[+] Enumerating subdomains from ridder .."
curl -s "https://riddler.io/search/exportcsv?q=pld:$url" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u > sub6
printf "${GREEN}\n[+] Enumerating subdomains from jldc .."
curl -s "https://jldc.me/anubis/subdomains/$url" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | cut -d "/" -f3 > sub7
printf "${GREEN}\n[+] Enumerating subdomains from omnisint .."
curl -s "https://sonar.omnisint.io/subdomains/$url" | cut -d "[" -f1 | cut -d "]" -f1 | cut -d "\"" -f 2 > sub8

sort sub1 sub2 sub3 sub4 sub5 sub6 sub7 sub8 | uniq | tee $url-all_subdomains
rm sub*

printf "${BLUE}\n[*] Subdomain Enumeration Completed!\n"
num=$( wc -l $url-all_subdomains | awk '{print $1; exit}')
printf "${WHITE}\n[*] Found $num subdomains for $url\n"

printf "${BLUE}\n[!] view the $url-all_subdomains file for results!\n\n"
