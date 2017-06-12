FROM scratch
MAINTAINER Rosco Pecoltran <rosco_pecoltran@msn.com>

# Copy certificates and generated binary
COPY ./certs/ca-certificates.crt /etc/ssl/certs/
COPY {{.APP_EXECTUABLE_FILENAME}} /app

# Container configuration
VOLUME ["/data"]
EXPOSE 1705

ENTRYPOINT ["/app/{{.APP_EXECTUABLE_FILENAME}}"]

# Metadata
LABEL org.label-schema.vendor="{{.APP_VENDOR}}" \
      org.label-schema.url="{{.APP_WEBSITE}}" \
      org.label-schema.name="{{.APP_NAME}}" \
      org.label-schema.description="{{.APP_DESCRIPTION}}" \    
      org.label-schema.version="$VERSION" \
      org.label-schema.docker.schema-version="1.0"