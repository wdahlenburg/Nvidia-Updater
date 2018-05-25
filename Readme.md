# Nvidia-Updater

A small script set up to update the nvidia proprietary drivers on linux. This came out of need for the fact that the Nvidia proprietary drivers are not updated through the regular package manager (apt-get). The benefit of using the proprietary drivers is the optimization for overclocking and that certain toolsets require the proprietary drivers such as hashcat. The downside of the drivers is that when Nvidia pushes an update Ubuntu fails to boot properly. 


This script can be added as a cronjob daily by appending to crontab -e:

0 12 * * * sh $FULL_PATH_TO_GIT_REPO/nvidia-updater.sh
