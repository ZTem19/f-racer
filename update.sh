#!/bin/bash

#Colors
RED='\033[0;31m'
CY='\033[0;36m'
NC='\033[0m'

moonrakerConf="/home/biqu/printer_data/config/moonraker.conf"
logFile="/home/biqu/f-racer/updateLog.txt"

commitHash=$(grep -A 1 "Supported Klipper Version" Version.txt  | tail -n 1 )
echo -e "${CY}Commit Hash:$commitHash ${NC}" >"$logFile"

sudo systemctl stop klipper

echo -e "${CY}Klipper stopped${NC}" >"$logFile"
cd ~/klipper

git fetch #Cache all new possible updates
git merge "$commitHash"	#Update local branch to specified commit 

if [ $? -eq 0 ]; then
	echo -e "${CY}Successfully updated klipper${NC}" >"$logFile"
else 
	echo -e "${RED}Something went wrong when updating Klipper${NC}" >"$logFile"
	exit 1
fi

echo -e "${CY}Updating ${moonrakerConf} ${NC}"
awk '/^\[update_manager klipper\] { found=1; next} found && /^pin: / {print "pin: ${commitHash}"; found=0; next} {print}' ${moonrakerConf} > temp && mv temp${moonrakerConf}

sudo systemctl start klipper
echo -e "${CY}Klipper started${NC}" >"$logFile"



