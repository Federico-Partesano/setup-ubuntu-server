#!/bin/bash
# Setup VNC con XFCE su Ubuntu Server 24.04
# Federico style 😎

# --- Aggiorna sistema ---
echo "Aggiornamento sistema..."
sudo apt update && sudo apt upgrade -y

# --- Installa desktop XFCE ---
echo "Installazione XFCE..."
sudo apt install -y xfce4 xfce4-goodies

sudo apt install libpam-modules
sudo apt install dbus-x11
# --- Installa TigerVNC ---
echo "Installazione TigerVNC..."
sudo apt install -y tigervnc-standalone-server tigervnc-common

# --- Configura password VNC ---
echo "Configura password VNC per l'utente corrente ($USER)..."
vncpasswd

# --- Configura xstartup per XFCE ---
echo "Configurazione ~/.vnc/xstartup..."
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup <<EOL
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

[ -r \$HOME/.Xresources ] && xrdb \$HOME/.Xresources

# Avvia XFCE senza &
dbus-launch --exit-with-session startxfce4
EOL
chmod +x ~/.vnc/xstartup

# --- Avvia VNC server iniziale ---
echo "Avvio VNC server..."
vncserver :1 -geometry 1920x1080 -depth 24

# --- Crea servizio systemd ---
echo "Creazione servizio systemd per VNC..."
sudo tee /etc/systemd/system/vncserver@.service > /dev/null <<EOL
[Unit]
Description=Start TigerVNC server at startup
After=syslog.target network.target

[Service]
Type=forking
User=$USER
PAMName=login
PIDFile=/home/$USER/.vnc/%H:%i.pid
ExecStartPre=-/usr/bin/vncserver -kill :%i > /dev/null 2>&1
ExecStart=/usr/bin/vncserver :%i -geometry 1920x1080 -depth 24
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
EOL

# --- Abilita e avvia servizio ---
echo "Abilitazione e avvio systemd service..."
sudo systemctl daemon-reload
sudo systemctl enable vncserver@1.service
sudo systemctl start vncserver@1.service


sudo systemctl set-default multi-user.target

echo "✅ Setup completato! Connettiti con il client VNC a localhost:5901 o IP_SERVER:5901"