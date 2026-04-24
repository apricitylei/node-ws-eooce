FROM golang:1.24-alpine AS builder

WORKDIR /tmp/app

RUN apk add --no-cache git ca-certificates tzdata wget && \
    wget https://raw.githubusercontent.com/eooce/serverless-xhttp/refs/heads/golang/go.mod -O go.mod && \
    wget https://raw.githubusercontent.com/eooce/serverless-xhttp/refs/heads/golang/go.sum -O go.sum && \
    go mod download && \
    wget https://raw.githubusercontent.com/eooce/serverless-xhttp/refs/heads/golang/main.go -O main.go

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app main.go

FROM alpine:latest

WORKDIR /tmp/app

RUN apk --no-cache add ca-certificates curl bash

COPY --from=builder /tmp/app/app .

RUN chmod +x app

EXPOSE 7860


    PORT=7860 \
    NAME=hug

CMD ["./app"]
