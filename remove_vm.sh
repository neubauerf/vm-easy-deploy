#!/bin/sh

IMAGE_DIR=/var/lib/libvirt/images
FORCE=0

export LANG=C
export LC_ALL=C

if [ `whoami` != "root" ]; then
  echo "Please use 'sudo'. This command requires root priviledge."
  exit 1
fi

if [ "$1" = "-f" ]; then
  FORCE=1
  shift
fi

if [ -z "$1" ]; then
  echo "Usage: $0 NAME"
  exit 1
fi
NAME=$1

virsh domstate $NAME | grep running > /dev/null
if [ $? -eq 0 ]; then
  if [ $FORCE -eq 1 ]; then
    virsh destroy $NAME
  else
    echo "Instance '$NAME' is running."
    echo "Use '-f' option to remove a running instance."
    exit 2
  fi
fi

virsh undefine $NAME
rm -v ${IMAGE_DIR}/${NAME}.img
