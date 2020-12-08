FROM alpine:latest
COPY ginweb /
COPY templates /templates

EXPOSE 5000
ENTRYPOINT ["/ginweb"]
