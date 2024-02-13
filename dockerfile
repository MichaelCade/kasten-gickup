# We get tools from tools image
# Tools are not up to date in debian repos
ARG TOOLS_IMAGE
ARG GICKUP_IMAGE
FROM ghcr.io/kanisterio/kanister-tools:0.105.0 AS TOOLS_IMAGE
FROM buddyspencer/gickup:latest AS GICKUP_IMAGE

# Actual image base
FROM ubuntu:23.10

# Install dependencies for copy
RUN apt update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt install -y git git-lfs ssl-cert tzdata && rm -rf /var/lib/apt/lists/*


# Install restic to take backups
COPY --from=TOOLS_IMAGE /usr/local/bin/restic /usr/local/bin/restic
# Update gosu from recent version
COPY --from=TOOLS_IMAGE /usr/local/bin/gosu /usr/local/bin/gosu
# Install kando
COPY --from=TOOLS_IMAGE /usr/local/bin/kando /usr/local/bin/kando

# Add gickup 
ADD gickup/gickup /usr/local/bin/

WORKDIR /
# Copy valid SSL certs from the builder for fetching github/gitlab/...
COPY --from=GICKUP_IMAGE /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
# Copy zoneinfo for getting the right cron timezone
COPY --from=GICKUP_IMAGE /usr/share/zoneinfo /usr/share/zoneinfo

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"

