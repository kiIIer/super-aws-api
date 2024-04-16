FROM --platform=linux/amd64 golang:1.22 as builder

WORKDIR /app

COPY go.mod .

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o super-aws-api

FROM --platform=linux/amd64 alpine:latest

COPY --from=builder /app/super-aws-api .

CMD ["./super-aws-api"]
