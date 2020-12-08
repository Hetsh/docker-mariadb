FROM library/alpine:20200917
RUN apk add --no-cache \
    mariadb=10.5.8-r0

# App user
ARG APP_USER="mysql"
ARG APP_GROUP="$APP_USER"
ARG APP_UID=1374
ARG APP_GID="$APP_UID"
RUN sed -i "s|$APP_USER:x:[0-9]\+:[0-9]\+|$APP_USER:x:$APP_UID:$APP_GID|" /etc/passwd && \
    sed -i "s|$APP_GROUP:x:[0-9]\+|$APP_GROUP:x:$APP_GID|" /etc/group

# Config & Volumes
ARG SOCK_DIR="/run/mysqld"
ARG DATA_DIR="/var/lib/mysql"
RUN mkdir "$SOCK_DIR" && \
    sed -i '/skip-networking/d' /etc/my.cnf.d/mariadb-server.cnf && \
    chown "$APP_USER":"$APP_GROUP" "$SOCK_DIR" "$DATA_DIR"
VOLUME ["$SOCK_DIR", "$DATA_DIR"]

#      Classic
EXPOSE 3306/tcp

USER "$APP_USER"
ENTRYPOINT ["mysqld"]
