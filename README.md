# couchbase-backup-gcs

Create a backup of a specified couchbase to Google Cloud Storage

## Configuration

Set the following environment variables:

| env variable | description |
|--------------|-------------|
| `COUCHBASE_HOST` | Hostname of couchbase |
| `COUCHBASE_USER` | Username of the couchbase user |
| `COUCHBASE_PASSWORD` | Password of the couchbase user |
| `GCS_BUCKET` | Google Cloud Storage bucket name |
| `BACKUP_NAME` | Name of the backup file, will be appended by the current date |
| `GOOGLE_APPLICATION_CREDENTIALS` | Path to mounted credentials file |
