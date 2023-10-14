#!/bin/bash

# Advanced System Maintenance Script 
# Author:Akhil Panwar
# Created on:10th october,2023
# This script will remove temporary files,update all the installled packages and create the system backup


#############################################333

# Define variables
backup_dir="/backup/$(date +'%Y-%m-%d')"
log_file="/var/log/system_maintenancei.log"
admin_email="panwarakhil033@gmail.com"  # Change to your admin's email address

# Function for logging messages with timestamps
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$log_file"
}

# function to ensure that the script must be run by a sudo or root user

if [ "$EUID" -ne 0 ]
then 
	echo "This script must be run with root or sudo"
	exit 1
fi


# Create log directory if it doesn't exist
if [ ! -d "$(dirname "$log_file")" ]; then
    mkdir -p "$(dirname "$log_file")"
fi

# Clean up temporary files
log "Cleaning up temporary files..."
if ! sudo apt-get clean && sudo apt-get autoremove --purge; then
    log "Error: Failed to clean temporary files."
    send_notification "Maintenance Error" "Failed to clean temporary files."
fi

# Update the package manager
log "Updating package manager..."
if ! sudo apt-get update; then
    log "Error: Failed to update package manager."
    send_notification "Maintenance Error" "Failed to update package manager."
fi

# Upgrade installed packages
log "Upgrading installed packages..."
if ! sudo apt-get upgrade -y; then
    log "Error: Failed to upgrade installed packages."
    send_notification "Maintenance Error" "Failed to upgrade installed packages."
fi

# Create a system backup
log "Creating a system backup in $backup_dir..."
if ! sudo mkdir -p "$backup_dir" || ! sudo tar -czvf "$backup_dir/system_backup.tar.gz" --exclude="$backup_dir" --directory="/" .; then
    log "Error: Failed to create a system backup."
    send_notification "Maintenance Error" "Failed to create a system backup."
else
    log "Maintenance tasks completed successfully."
fi

