sudo apt update
sudo apt install -y cpufrequtils
echo "✅ Impostazione governor powersave su tutte le CPU..."
sudo cpufreq-set -r -g powersave

# --- Modifica permanente ---
echo "✅ Configurazione permanente in /etc/default/cpufrequtils..."
# Se il file non esiste, lo crea
if [ ! -f /etc/default/cpufrequtils ]; then
    echo 'GOVERNOR="powersave"' | sudo tee /etc/default/cpufrequtils > /dev/null
else
    # Modifica la riga esistente o aggiunge se manca
    if grep -q "^GOVERNOR=" /etc/default/cpufrequtils; then
        sudo sed -i 's/^GOVERNOR=.*/GOVERNOR="powersave"/' /etc/default/cpufrequtils
    else
        echo 'GOVERNOR="powersave"' | sudo tee -a /etc/default/cpufrequtils > /dev/null
    fi
fi

echo "✅ Riavvio cpufrequtils per applicare le modifiche..."
sudo systemctl restart cpufrequtils

echo "✅ Governor CPU impostato su powersave!"

cpufreq-info