#!/bin/bash
set -e

/etc/init.d/xrdp start

echo "Hello, this is a container with SeisUnix that can be accessible via Remote Desktop (RDP)."
echo "Contributions for this container image, please access https://github.com/maltempi/SeisUnixContainer"
echo "----------------"
echo "Default RDP creds:"
echo "user: ubuntu"
echo "password: ubuntu"
echo "----------------"
echo "[ Ready for connection ]"

exec "$@"

# This makes our container running forever (or until user wants.)
tail -f /dev/null
