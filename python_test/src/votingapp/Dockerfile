######## Builder ########
FROM golang:1.13.4-alpine AS builder

RUN apk update && apk add --no-cache git && rm -rf /var/cache/apk/*
# && If the cmd works then execute the next one
RUN go get github.com/gorilla/websocket && \
    go get github.com/labstack/echo

COPY . .

RUN go build -o /build/votingapp && \
    cp -r ui /build

######## RUNTIME ########

FROM alpine

WORKDIR /app
COPY --from=builder build .

ENTRYPOINT [ "./votingapp" ]