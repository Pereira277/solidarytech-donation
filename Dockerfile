# Build stage
FROM golang:1.24-alpine AS builder

WORKDIR /build

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o server .

# Runtime stage
FROM alpine:3.19

RUN addgroup -S app && adduser -S -G app app

WORKDIR /app

COPY --from=builder /build/server .

USER app

EXPOSE 8082

ENTRYPOINT ["./server"]
