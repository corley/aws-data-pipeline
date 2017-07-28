#!/bin/bash

# Input arguments
source=$1
destination=$2
efsid=$3
region=$4

# Prepare system for rsync
#echo 'sudo yum -y update'
#sudo yum -y update
echo 'sudo yum -y install nfs-utils'
sudo yum -y install nfs-utils
echo 'sudo mkdir /backup'
sudo mkdir /backup
echo 'sudo mkdir /mnt/backups'
sudo mkdir /mnt/backups
#echo "sudo mount -t nfs -o nfsvers=4.1 -o rsize=1048576 -o wsize=1048576 -o timeo=600 -o retrans=2 -o hard $source /backup"
#sudo mount -t nfs -o nfsvers=4.1 -o rsize=1048576 -o wsize=1048576 -o timeo=600 -o retrans=2 -o hard $source /backup
echo "sudo mount -t nfs $source /backup"
sudo mount -t nfs $source /backup

# we need to decrement retain because we start counting with 0 and we need to remove the oldest backup
let "retain=$retain-1"
let "folder=`date +%Y%m%d%H%M`"

if [ ! -d /mnt/backups/efsbackup-logs ]; then
  echo "sudo mkdir -p /mnt/backups/efsbackup-logs"
  sudo mkdir -p /mnt/backups/efsbackup-logs
  echo "sudo chmod 700 /mnt/backups/efsbackup-logs"
  sudo chmod 700 /mnt/backups/efsbackup-logs
fi

echo "sudo rm /tmp/efs-backup.log"
sudo rm /tmp/efs-backup.log
echo "sudo aws s3 cp --region $region --recursive /backup s3://$destination/$efsid/$folder"
sudo aws s3 cp --region $region --recursive /backup s3://$destination/$efsid/$folder > /tmp/efs-backup.log
rsyncStatus=$?
echo "sudo cp /tmp/efs-backup.log /mnt/backups/efsbackup-logs/$efsid-`date +%Y%m%d-%H%M`.log"
sudo cp /tmp/efs-backup.log /mnt/backups/efsbackup-logs/$efsid-`date +%Y%m%d-%H%M`.log
exit $rsyncStatus
