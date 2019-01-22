FROM couchbase:community-4.0.0

RUN mkdir /data
ADD backup.sh /scripts/backup.sh
RUN chmod +x /scripts/backup.sh

CMD ["/scripts/backup.sh"]
