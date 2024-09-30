# Build Production Console in Node
FROM node:14.17-alpine as build

RUN apk add --no-cache git

WORKDIR /app

COPY . .

RUN npm install

RUN npm run prepare

# Serve built project with nginx
FROM nginx:mainline-alpine

WORKDIR /usr/share/nginx/html

# Copiar el proyecto construido desde el contenedor anterior
COPY --from=build /app/dist  ./

# Copiar configuración personalizada de NGINX
COPY nginx.conf /etc/nginx/sites-enabled/openhim-console

# Copiar script de entrada personalizado
COPY ./docker-entrypoint.sh /usr/local/bin/

# Instalar Certbot
RUN apk add --no-cache certbot

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT [ "/bin/sh", "/usr/local/bin/docker-entrypoint.sh" ]
