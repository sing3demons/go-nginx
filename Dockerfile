FROM golang:alpine as builder

RUN apk --no-cache add gcc g++ make
RUN apk add git
WORKDIR /go/src/app
COPY . .
RUN go mod tidy

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .



FROM alpine:latest  
RUN apk --no-cache add ca-certificates
WORKDIR /usr/bin

COPY --from=builder /go/src/app .
EXPOSE 8080

CMD ["./main"] 
