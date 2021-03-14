#!/usr/bin/env bash


# Abort on any error
set -e -u

# Simpler git usage, relative file paths
CWD=$(dirname "$0")
cd "$CWD"

# Load helpful functions
source libs/common.sh
source libs/docker.sh

# Check access to docker daemon
assert_dependency "docker"
if ! docker version &> /dev/null; then
	echo "Docker daemon is not running or you have unsufficient permissions!"
	exit -1
fi

# Build the image
APP_NAME="mariadb"
IMG_NAME="hetsh/$APP_NAME"
docker build --tag "$IMG_NAME:latest" --tag "$IMG_NAME:$_NEXT_VERSION" .

case "${1-}" in
	# Test with temporary database
	"--test")
		# Create temporary directory
		TMP_DIR=$(mktemp -d "/tmp/$APP_NAME-XXXXXXXXXX")
		add_cleanup "rm -rf $TMP_DIR"

		# Bootstrap DB
		assert_dependency "mariadb-install-db"
		mariadb-install-db --datadir="$TMP_DIR"

		# Apply permissions
		extract_var APP_UID "./Dockerfile" "\d+"
		chown -R "$APP_UID" "$TMP_DIR"

		# Start test
		docker run \
		--rm \
		--tty \
		--interactive \
		--publish 3306:3306/tcp \
		--mount type=bind,source="$TMP_DIR",target=/var/lib/mysql \
		--mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly \
		--name "$APP_NAME" \
		"$IMG_NAME"
	;;
	# Push image to docker hub
	"--upload")
		if ! tag_exists "$IMG_NAME"; then
			docker push "$IMG_NAME:latest"
			docker push "$IMG_NAME:$_NEXT_VERSION"
		fi
	;;
esac
