#!/bin/bash
set -ex # exit if command fails and display commands https://www.peterbe.com/plog/set-ex
# Removes sudo and sets default password for being installed during a AWS CodeBuild run for CI

#Request sudo permissions
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi



# Check prerequisites
apt-get update
apt-get install -y supervisor xvfb fluxbox x11vnc websockify


#Clone noVNC into proper /opt/ directory
echo "Cloning noVNC..."
echo

git clone git://github.com/kanaka/noVNC /opt/noVNC/

#Copy supervisord configuration to proper configuration directory
echo "Configuring supervisord..."
echo

cp supervisord.conf ${HOME}/.config/supervisord.conf


#Create the proper directory for the script
echo "Install run script..."
echo

mkdir -p /opt/c9vnc

#Copy the run script to proper /opt/ directory
\cp run.sh /opt/c9vnc/c9vnc.sh


#Symlink script
ln -s /opt/c9vnc/c9vnc.sh /usr/local/bin/c9vnc


#Export X11 Settings
echo "Configuring X11"
echo

mkdir -p /tmp/X11
echo export XDG_RUNTIME_DIR=/tmp/C9VNC >> ~/.bashrc
echo export DISPLAY=:99.0 >> ~/.bashrc
source ~/.bashrc

