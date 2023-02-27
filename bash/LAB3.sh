#!/bin/bash

# Check if lxd is installed and install it if necessary
if command -v lxd >/dev/null 2>&1; then
	echo "lxd is already installed."
else
	echo "Installing lxd... You may need to enter your password."
	sleep 2
	sudo snap install lxd >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "Successfully installed lxd."
    	else
		echo "Failed to install lxd."
		exit 1
	fi
fi

# Initialize lxd if no lxdbr0 interface exists
if ip link show lxdbr0 >/dev/null 2>&1; then
	echo "lxdbr0 interface already exists."
else
	echo "Initializing lxd..."
	sleep 2
	sudo lxd init --auto >/dev/null 2>&1
	if [ $? -eq 0 ]; then
        	echo "Successfully initialized lxd."
        else
		echo "Failed to initialize lxd."
		exit 1
	fi
fi

# Launch container named COMP2101-S22 if necessary
if sudo lxc list | grep -q COMP2101-S22; then
	echo "Container COMP2101-S22 already exists."
else
	echo "Launching container..."
	sleep 2
	sudo lxc launch ubuntu:20.04 COMP2101-S22 >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "Successfully launched container."
	else
		echo "Failed to launch container."
		exit 1
	fi
fi

# Add or update entry in /etc/hosts if necessary
if grep -q "COMP2101-S22" /etc/hosts; then
	echo "Entry for COMP2101-S22 already exists in /etc/hosts."
else
	ip=$(lxc info COMP2101-S22 | grep -w inet | head -1 | awk '{print$2}' | cut -d '/' -f1)
	echo "Adding entry to /etc/hosts..."
	sleep 2
	echo "$ip COMP2101-S22" | sudo tee -a /etc/hosts >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "Successfully added entry to /etc/hosts."
	else
		echo "Failed to add entry to /etc/hosts."
		exit 1
	fi
fi

# Install Apache2 in the container if necessary
if sudo lxc exec COMP2101-S22 -- which apache2 >/dev/null 2>&1; then
	echo "Apache2 is already installed in the container."
else
	echo "Installing Apache2..."
	sleep 2
	sudo lxc exec COMP2101-S22 -- apt-get install -y apache2 >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "Successfully installed Apache2."
	else
		echo "Failed to install Apache2."
		exit 1
	fi
fi

# Retrieve default web page from container's web service and notify user
if curl -s http://COMP2101-S22 >/dev/null 2>&1; then
	echo "Successfully retrieved default web page!"
else
	echo "Failed to retrieve default web page."
	exit 1
fi


