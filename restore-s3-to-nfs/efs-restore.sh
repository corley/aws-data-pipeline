#!/bin/bash

# Input arguments
source=$1
destination=$2
region=$3

# Prepare system for rsync
#echo 'sudo yum -y update'
#sudo yum -y update
echo 'sudo yum -y install nfs-utils'
sudo yum -y install nfs-utils
echo 'sudo mkdir /backup'
sudo mkdir /backup
echo 'sudo mkdir /mnt/backups'
sudo mkdir /mnt/backups
#echo "sudo mount -t nfs -o nfsvers=4.1 -o rsize=1048576 -o wsize=1048576 -o timeo=600 -o retrans=2 -o hard $destination /backup"
#sudo mount -t nfs -o nfsvers=4.1 -o rsize=1048576 -o wsize=1048576 -o timeo=600 -o retrans=2 -o hard $destination /backup
echo "sudo mount -t nfs $destination /backup"
sudo mount -t nfs $destination /backup

if [ ! -d /mnt/backups/efsbackup-logs ]; then
  echo "sudo mkdir -p /mnt/backups/efsbackup-logs"
  sudo mkdir -p /mnt/backups/efsbackup-logs
  echo "sudo chmod 700 /mnt/backups/efsbackup-logs"
  sudo chmod 700 /mnt/backups/efsbackup-logs
fi

echo "sudo rm /tmp/efs-restore.log"
sudo rm /tmp/efs-restore.log
echo "sudo aws s3 sync --region $region s3://$1 /backup"
sudo aws s3 sync --region $region s3://$source /backup
rsyncStatus=$?
exit $rsyncStatus
