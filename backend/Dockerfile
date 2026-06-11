# Stage 1: Build
FROM golang:1.26.4-alpine AS builder

WORKDIR /app

COPY . .
RUN go mod tidy && CGO_ENABLED=0 GOOS=linux go build -o skillpulse .

# Stage 2: Run
FROM alpine:3.23

RUN apk update && \
    apk upgrade && \
    apk add --no-cache ca-certificates

WORKDIR /app

COPY --from=builder /app/skillpulse .

EXPOSE 8080

CMD ["./skillpulse"]
