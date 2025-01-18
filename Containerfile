FROM alpine:3.21

ENV ACTIVATION_BYTES=
ENV REMOVE_PROCESSED_FILES=0

RUN apk add --no-cache ffmpeg bash

RUN mkdir /consume /staging
VOLUME /consume
VOLUME /staging

RUN mkdir /app
COPY audible-tool.sh /app/audible-tool
RUN chmod +x /app/audible-tool
  
WORKDIR /app
ENTRYPOINT ["/app/audible-tool", "/consume", "/staging"]
