# Go Ethereum
Simple to set up Ethereum node with Geth client.

## Running the server
```bash
docker run --detach --name geth --publish 8545:8545/tcp --publish 8546:8546/tcp --publish 30303:30303/tcp --publish 30303:30303/udp hetsh/geth
```

## Stopping the container
```bash
docker stop geth
```

## Configuring
Geth can be configured via [cli-options](https://geth.ethereum.org/docs/interface/command-line-options) that can be appended at the end of a `docker run`:
```bash
docker run ... hetsh/geth --syncmode "light"
```
A config file can be specified the same way:
```bash
docker run ... hetsh/geth --config "path/to/config"
```

## Creating persistent storage
```bash
STORAGE="/path/to/storage"
mkdir -p "$STORAGE"
chown -R 1373:1373 "$STORAGE"
```
`1373` is the numerical id of the user running the server (see Dockerfile).
The user must have RW access to the storage directory.
Start the server with the additional mount flags:
```bash
docker run --mount type=bind,source=/path/to/storage,target=/geth-data ...
```

## Time
Synchronizing the timezones will display the correct time in the logs.
The timezone can be shared with this mount flag:
```bash
docker run --mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly ...
```

## Automate startup and shutdown via systemd
The systemd unit can be found in my GitHub [repository](https://github.com/Hetsh/docker-geth).
```bash
systemctl enable geth --now
```
By default, the systemd service assumes `/apps/geth` for storage and `/etc/localtime` for timezone.
Since this is a personal systemd unit file, you might need to adjust some parameters to suit your setup.

## Fork Me!
This is an open project hosted on [GitHub](https://github.com/Hetsh/docker-geth).
Please feel free to ask questions, file an issue or contribute to it.