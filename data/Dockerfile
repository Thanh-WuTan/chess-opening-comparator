FROM mysql:8.0

ENV MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
ENV MYSQL_DATABASE=chess_openings


COPY schema.sql /docker-entrypoint-initdb.d/schema.sql

EXPOSE 3306

VOLUME /var/lib/mysql