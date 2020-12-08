FROM alpine:latest
COPY ginweb /
COPY templates /

EXPOSE 5000
ENTRYPOINT ["/ginweb"]
