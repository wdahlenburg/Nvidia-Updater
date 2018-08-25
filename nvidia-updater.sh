#!/bin/bash

# Nvidia-Updater
# A small script to check if an update is available for the nvidia proprietary drivers for linux.
# Written by Wyatt Dahlenburg

BIN="/usr/bin/nvidia-settings";
if [ ! -f $BIN ]; then
   echo "nvidia-settings is not installed. Can not determine version.";
   exit;
else
   CURRENT_VERSION=$(nvidia-settings -v | grep version | awk '{print $3}');
   echo "Nvidia driver is currently $CURRENT_VERSION";
fi

TARGET_URL=$(curl -s "https://www.nvidia.com/Download/processDriver.aspx?psid=101&pfid=815&rpf=1&osid=12&lid=1&lang=en-us&ctk=0");

if [[ ! $TARGET_URL = *"https://"* ]]; then
  echo "Missing https"
  TARGET_URL=$(printf "https:"; cut -d':' -f2 <<<"$TARGET_URL")
fi

NVIDIA_NEWEST_VERSION=$(curl -s $TARGET_URL |  grep -A1 -w tdVersion | tail -n1 | awk '{$1=$1};1' | tr -d $'\r');
echo "Nvidia's current version is $NVIDIA_NEWEST_VERSION";

if (( $(echo "$NVIDIA_NEWEST_VERSION > $CURRENT_VERSION" | bc -l) )); then
	echo "Updating Nvidia driver";
else
	echo "Nvidia driver is up to date";
	exit;
fi

echo "Downloading driver"
wget http://us.download.nvidia.com/XFree86/Linux-x86_64/$NVIDIA_NEWEST_VERSION/NVIDIA-Linux-x86_64-$NVIDIA_NEWEST_VERSION.run -O ~/Downloads/NVIDIA-Linux-x86_64-$NVIDIA_NEWEST_VERSION.run -q --show-progress

echo "Stopping X-Server";
service gdm stop
service lightdm stop
service systemd-logind stop

chmod +x ~/Downloads/NVIDIA-Linux-x86_64-$NVIDIA_NEWEST_VERSION.run

sh ~/Downloads/NVIDIA-Linux-x86_64-$NVIDIA_NEWEST_VERSION.run -a -q -s

echo "Restarting X-Server";
service gdm start
service lightdm start
service systemd-logind start
