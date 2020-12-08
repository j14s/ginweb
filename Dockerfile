FROM alpine:latest
COPY ginweb /
COPY templates /templates
COPY images/favicon.ico /

EXPOSE 5000
ENTRYPOINT ["/ginweb"]
