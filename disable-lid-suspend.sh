#!/bin/bash
# Disabilita sospensione alla chiusura del laptop su Ubuntu 24.04

echo "Disabilitando sospensione alla chiusura del laptop..."

# --- Modifica logind.conf ---
sudo sed -i 's/^#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sudo sed -i 's/^#HandleLidSwitchDocked=suspend/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf

# --- Riavvia systemd-logind per applicare le modifiche ---
echo "Riavvio systemd-logind..."
sudo systemctl restart systemd-logind

echo "✅ Sospensione alla chiusura del laptop disabilitata!"
