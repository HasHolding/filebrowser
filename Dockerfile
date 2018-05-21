FROM golang:1.10-alpine
ARG VERSION=v1.7.1
RUN apk add --no-cache git 
RUN apk add --update openssl
WORKDIR /go/src/github.com/filebrowser/filebrowser
RUN wget https://github.com/filebrowser/filebrowser/archive/${VERSION}.tar.gz
RUN tar -xvf ${VERSION}.tar.gz --strip 1
RUN go get ./...
WORKDIR /go/src/github.com/filebrowser/filebrowser/cmd/filebrowser
RUN CGO_ENABLED=0 go build -a -installsuffix cgo -ldflags "-X main.version=${VERSION}"
FROM hasholding/alpine-base
LABEL maintainer "Levent SAGIROGLU <LSagiroglu@gmail.com>"

VOLUME /shared 

ENV FB_ROOT "/" 

COPY entrypoint.sh /bin/entrypoint.sh 
COPY --from=0 /go/src/github.com/filebrowser/filebrowser/cmd/filebrowser/filebrowser /bin/filebrowser
COPY README.md /shared/README.md 
EXPOSE 80 
ENTRYPOINT ["/bin/entrypoint.sh"]
