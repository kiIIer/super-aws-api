#!/bin/sh

CONTAINER_NAME="super-aws-api"
VOLUME_PATH="/etc/ssl"
EMAIL="michael.molchanov.2004@gmail.com"

sudo docker stop $CONTAINER_NAME
sudo docker rm $CONTAINER_NAME

if ! command -v certbot > /dev/null; then
    sudo snap install core; sudo snap refresh core
    sudo snap install --classic certbot
    sudo ln -sf /snap/bin/certbot /usr/bin/certbot
fi

if [ ! -d "/etc/letsencrypt/live/kiiier.top" ]; then
    sudo certbot certonly --non-interactive --standalone --agree-tos --email $EMAIL -d kiiier.top
else
    sudo certbot renew --non-interactive --standalone --agree-tos --email $EMAIL
fi

if [ -f "/etc/letsencrypt/live/kiiier.top/fullchain.pem" ] && [ -f "/etc/letsencrypt/live/kiiier.top/privkey.pem" ]; then
    sudo mkdir -p $VOLUME_PATH
    sudo cp /etc/letsencrypt/live/kiiier.top/fullchain.pem $VOLUME_PATH/cert.pem
    sudo cp /etc/letsencrypt/live/kiiier.top/privkey.pem $VOLUME_PATH/key.pem
    sudo chmod 644 $VOLUME_PATH/cert.pem
    sudo chmod 600 $VOLUME_PATH/key.pem

    sudo docker run -d --name $CONTAINER_NAME -p 443:443 \
      -e CERT_PATH="$VOLUME_PATH/cert.pem" \
      -e KEY_PATH="$VOLUME_PATH/key.pem" \
      -v $VOLUME_PATH:$VOLUME_PATH:ro \
      kiiier/super-aws-api:latest
else
    echo "Certificate or key file not found, aborting."
fi
