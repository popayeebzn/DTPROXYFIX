#!/bin/bash

# Instalação do DTPROXY
bash <(curl -sL https://raw.githubusercontent.com/PhoenixxZ2023/proxy/main/install.sh)

# Comando para abrir a porta 80 DTPROXY
screen -dmS proxy /usr/bin/proxy --port 80 --http --ssh-only --response CONECT

# Criação do script de reinicialização da porta
cat <<EOL | sudo tee /usr/local/bin/reiniciar_porta.sh
#!/bin/bash

# Defina a porta que você deseja reiniciar
PORTA=80

# Reinicia o serviço associado à porta
sudo systemctl restart proxy-80

# Log da execução
echo "Reiniciou o serviço em \$(date)" >> /var/log/reiniciar_porta.log
EOL

# Torna o script executável
sudo chmod +x /usr/local/bin/reiniciar_porta.sh

# Configuração do cron para executar o script a cada 5 minutos
(crontab -l 2>/dev/null; echo "*/5 * * * * /usr/local/bin/reiniciar_porta.sh") | crontab -

# Garante que o diretório e o arquivo de log existam
sudo mkdir -p /var/log/
sudo touch /var/log/reiniciar_porta.log
sudo chmod 644 /var/log/reiniciar_porta.log

# Exibe o log
cat /var/log/reiniciar_porta.log
