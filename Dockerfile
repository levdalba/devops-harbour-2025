FROM golang:1.24 AS builder

WORKDIR /app

COPY go.mod ./

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o main main.go

FROM alpine:latest

WORKDIR /root/

COPY --from=builder /app/main .

EXPOSE 4444

CMD ["./main"]
