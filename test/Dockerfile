FROM alpine

RUN apk update && apk add --no-cache curl && apk add --no-cache jq && rm -rf /var/cache/apk/*

COPY test.sh .
RUN chmod +x ./test.sh

ENTRYPOINT [ "./test.sh" ]