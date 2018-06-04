#!/bin/bash

clear
echo -e "\033[01;35m -------------------------------------------------"
echo -e "\033[01;35m|                  \033[01;33m    ADM VPS\033[01;35m                   |"
echo -e "\033[01;35m -------------------------------------------------"
echo ""
echo -e "\033[01;36mAguarde..."
echo ""
speedtest > /tmp/connectiontest
IP=$(cat /tmp/connectiontest | grep -E "Testing from" | cut -d "(" -f2 | cut -d ")" -f1)
HOSTED=$(cat /tmp/connectiontest | grep "Hosted by" | cut -d " " -f3-)
DOWNLOAD=$(cat /tmp/connectiontest  | grep -E "Download" | cut -d " " -f2,3)
UPLOAD=$(cat /tmp/connectiontest  | grep -E "Upload" | cut -d " " -f2,3)
echo -e "\033[01;37mIP:\033[01;31m $IP"
echo -e "\033[01;37mHOSPEDADO POR:\033[01;31m $HOSTED"
echo -e "\033[01;37mVELOCIDADE DE DOWNLOAD:\033[01;31m $DOWNLOAD"
echo -e "\033[01;37mVELOCIDADE DE UPLOAD:\033[01;31m $UPLOAD"
echo ""
while true; do
  echo -ne "\033[01;33mDeseja refazer o teste? [N/Y]:\033[01;37m "; read NY
  if [ "$NY" = "N" ]; then
    extra-menu
    exit
  else
  if [ "$NY" = "Y" ]; then
    connectiontest
    exit
  fi
  fi
done