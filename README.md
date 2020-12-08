# MariaDB
Small and easy to set up MySQL instance using MariaDB.

## Bootstrapping
MariaDB can't run without a valid database installation:
```bash
STORAGE="/path/to/storage"
mariadb-install-db --datadir="$STORAGE"
chown -R 1374:1374 "$STORAGE"
```

## Running the server
```bash
docker run --detach --name mariadb --publish 3306:3306/tcp --mount type=bind,source=/path/to/storage,target=/var/lib/mysql hetsh/mariadb
```

## Stopping the container
```bash
docker stop mariadb
```

## Time
Synchronizing the timezones will display the correct time in the logs.
The timezone can be shared with this mount flag:
```bash
docker run --mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly ...
```

## Automate startup and shutdown via systemd
The systemd unit can be found in my GitHub [repository](https://github.com/Hetsh/docker-mariadb).
```bash
systemctl enable mariadb --now
```
By default, the systemd service assumes `/apps/mariadb` for storage and `/etc/localtime` for timezone.
Since this is a personal systemd unit file, you might need to adjust some parameters to suit your setup.

## Fork Me!
This is an open project hosted on [GitHub](https://github.com/Hetsh/docker-mariadb).
Please feel free to ask questions, file an issue or contribute to it.
