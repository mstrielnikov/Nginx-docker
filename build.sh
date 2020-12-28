#/usr/bin/sh

IMAGE_NAME="ngninx"
VERSION="0.1"i
docker build --label "$IMAGE_NAME" .
docker run -p 8080:80 "$IMAGE_NAME"

exit 0;
