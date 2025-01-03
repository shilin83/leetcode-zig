FROM alpine:3.21

RUN apk add --no-cache zig

WORKDIR /app

COPY . .

RUN zig build test --summary all

CMD ["zig", "build", "run"]
