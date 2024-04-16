#!/bin/bash

CONTAINER_NAME="super-aws-api"
VOLUME_PATH="/etc/ssl"

docker stop $CONTAINER_NAME

certbot renew --non-interactive --standalone

mkdir -p $VOLUME_PATH

cp /etc/letsencrypt/live/ec2-16-16-57-192.eu-north-1.compute.amazonaws.com/fullchain.pem $VOLUME_PATH/cert.pem
cp /etc/letsencrypt/live/ec2-16-16-57-192.eu-north-1.compute.amazonaws.com/privkey.pem $VOLUME_PATH/key.pem

chmod 644 $VOLUME_PATH/cert.pem
chmod 600 $VOLUME_PATH/key.pem

docker run -d --name $CONTAINER_NAME -p 443:443 \
  -e CERT_PATH="$VOLUME_PATH/cert.pem" \
  -e KEY_PATH="$VOLUME_PATH/key.pem" \
  -v $VOLUME_PATH:$VOLUME_PATH:ro \
  kiiier/super-aws-api:latest
