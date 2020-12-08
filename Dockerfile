FROM alpine:latest
COPY ginweb /
COPY templates /templates
COPY favicon.ico /

EXPOSE 5000
ENTRYPOINT ["/ginweb"]
