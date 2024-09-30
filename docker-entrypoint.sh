#!/bin/sh

# Set defaults for the environment variables
export OPENHIM_CONSOLE_PROTOCOL=${OPENHIM_CONSOLE_PROTOCOL:-"https"}
export OPENHIM_CONSOLE_HOSTPATH=${OPENHIM_CONSOLE_HOSTPATH:-""}
export OPENHIM_CORE_MEDIATOR_HOSTNAME=${OPENHIM_CORE_MEDIATOR_HOSTNAME:-"http://15.228.12.79/"}
export OPENHIM_MEDIATOR_API_PORT=${OPENHIM_MEDIATOR_API_PORT:-"8081"}
export OPENHIM_MEDIATOR_HEALTH_WARNING_TIMEOUT=${OPENHIM_MEDIATOR_HEALTH_WARNING_TIMEOUT:-"60"}
export OPENHIM_MEDIATOR_HEALTH_DANGER_TIMEOUT=${OPENHIM_MEDIATOR_HEALTH_DANGER_TIMEOUT:-"120"}
export OPENHIM_CONSOLE_SHOW_LOGIN=${OPENHIM_CONSOLE_SHOW_LOGIN:-"true"}
export KC_OPENHIM_SSO_ENABLED=${KC_OPENHIM_SSO_ENABLED:-"false"}
export KC_FRONTEND_URL=${KC_FRONTEND_URL:-"http://15.228.12.79:9088"}
export KC_REALM_NAME=${KC_REALM_NAME:-"platform-realm"}
export KC_OPENHIM_CLIENT_ID=${KC_OPENHIM_CLIENT_ID:-"openhim-oauth"}

cat config/default-env.json | envsubst | tee config/default.json

# Verificar si el certificado ya existe, de lo contrario, generarlo
if [ ! -f "/etc/letsencrypt/live/$YOUR_HOSTNAME/fullchain.pem" ]; then
    certbot certonly --webroot -w /usr/share/nginx/html -d $YOUR_HOSTNAME
    chmod 750 /etc/letsencrypt/live/
    chmod 750 /etc/letsencrypt/archive/
    chown :nginx /etc/letsencrypt/live/ /etc/letsencrypt/archive/
fi

# Agregar la renovación automática de certificados al crontab
echo "0 0 * * * certbot renew --no-self-upgrade >> /var/log/letsencrypt-renewal.log" | crontab -

# Iniciar NGINX
nginx -g "daemon off;"
