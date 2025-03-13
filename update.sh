#!/bin/bash

commitHash=$(grep -A 1  <Version "Supported Klipper Version" | tail -n 1 )
echo "$commitHash"

sudo systemctl stop klipper

echo "Klipper stopped"
cd ~/klipper
git checkout "$commitHash"

sudo systemctl start klipper
echo "Klipper started"
