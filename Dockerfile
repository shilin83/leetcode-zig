FROM alpine:latest

RUN apk add --no-cache zig

WORKDIR /app

COPY . .

RUN zig build test --summary all

CMD ["/bin/sh", "echo success!"]
