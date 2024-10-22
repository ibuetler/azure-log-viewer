FROM golang:latest AS websocketd
ENV CGO_ENABLED=0
RUN go install github.com/ibuetler/websocketd@latest


FROM hackinglab/alpine-base-hl:3.2
LABEL maintainer="Ivan Buetler <ivan.buetler@hacking-lab.com>"

COPY --from=websocketd /go/bin/websocketd /usr/bin/websocketd

# Add the files
ADD root /

RUN apk add --no-cache --update \
        nodejs \
        npm \
        sudo \
        nginx \
	figlet \
	dcron \
        apache2-utils \
        openssl && \
	addgroup -S node && adduser -S node -G node && \
	cd /opt/nodejs && \
	npm i && \
	chown -R nginx:www-data /var/lib/nginx && \
	chown -R nginx:www-data /opt/www && \
	chown -R node:node /opt/nodejs && \
	chown -R node:node /opt/data && \
	rm -rf /var/cache/apk/* 

RUN chmod +x /etc/cont-init.d/20-config

#USER node
EXPOSE 3000

