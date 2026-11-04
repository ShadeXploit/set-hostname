#!/bin/bash

# Ensure the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "[-] Please run this script with sudo or as root."
  exit 1
fi

# Read from the terminal so this also works when piped (curl ... | sudo bash)
read -rp "[?] Enter the new hostname: " NEW_HOSTNAME </dev/tty

# Ensure the input is not empty
if [ -z "$NEW_HOSTNAME" ]; then
  echo "[-] Error: Hostname cannot be empty."
  exit 1
fi

# RFC 1123 hostname: letters, digits, hyphens; max 63 chars; no leading/trailing hyphen
if ! [[ "$NEW_HOSTNAME" =~ ^[A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?$ ]]; then
  echo "[-] Error: Invalid hostname."
  exit 1
fi

echo "[+] Setting system hostname to: $NEW_HOSTNAME"

# Apply the hostname immediately and persistently
if command -v hostnamectl >/dev/null 2>&1; then
  hostnamectl set-hostname "$NEW_HOSTNAME"
else
  hostname "$NEW_HOSTNAME"
  echo "$NEW_HOSTNAME" > /etc/hostname
fi

# Update /etc/hosts to prevent sudo warnings about unknown hostnames
if grep -q "127.0.1.1" /etc/hosts; then
  sed -i "s/127.0.1.1.*/127.0.1.1\t$NEW_HOSTNAME/" /etc/hosts
else
  echo -e "127.0.1.1\t$NEW_HOSTNAME" >> /etc/hosts
fi

echo "[+] Hostname successfully changed to: $NEW_HOSTNAME"
