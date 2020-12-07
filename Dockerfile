FROM alpine:latest
COPY ginweb /

EXPOSE 5000
ENTRYPOINT ["/ginweb"]
