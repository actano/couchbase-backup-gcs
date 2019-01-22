#!/bin/bash

if [ -z $COUCHBASE_HOST ] ; then
    echo "You must specify a COUCHBASE_HOST env var"
    exit 1
fi

if [ -z $GCS_BUCKET ]; then
    echo "You must specify a google cloud storage GCS_BUCKET address such as gs://my-backups/"
    exit 1
fi

if [ -z $BACKUP_NAME ]; then
    BACKUP_NAME=couchbase_backup
fi

CURRENT_DATE=$(date -u +"%Y-%m-%dT%H%M%SZ")
BACKUP_SET="$BACKUP_NAME-$CURRENT_DATE"

echo "Activating google credentials before beginning"
gcloud auth activate-service-account --key-file "$GOOGLE_APPLICATION_CREDENTIALS"

if [ $? -ne 0 ] ; then
    echo "Credentials failed; no way to copy to google."
    echo "Ensure GOOGLE_APPLICATION_CREDENTIALS is appropriately set."
fi

echo "=============== Couchbase Backup ==============================="
echo "Beginning backup from $COUCHBASE_HOST to /data/$BACKUP_SET"
echo "To google storage bucket $GCS_BUCKET using credentials located at $GOOGLE_APPLICATION_CREDENTIALS"
echo "============================================================"

/opt/couchbase/bin/cbbackup -m full -u ${COUCHBASE_USER} -p ${COUCHBASE_PASSWORD} http://${COUCHBASE_HOST} /data/$BACKUP_SET

echo "Backup size:"
du -hs "/data/$BACKUP_SET"

echo "Tarring -> /data/$BACKUP_SET.tar"
tar -cvf "/data/$BACKUP_SET.tar" "/data/$BACKUP_SET" --remove-files

echo "Zipping -> /data/$BACKUP_SET.tar.gz"
gzip -9 "/data/$BACKUP_SET.tar"

echo "Zipped backup size:"
du -hs "/data/$BACKUP_SET.tar.gz"

echo "Pushing /data/$BACKUP_SET.tar.gz -> $GCS_BUCKET"
gsutil cp "/data/$BACKUP_SET.tar.gz" "$GCS_BUCKET"

exit $?
