# In general the purpose of this file is to get known the rules of how to correctly build project and for building automation process. 
APP := $(shell basename $(shell git remote get-url origin))
REGISTRY := artemvoloshyn
REGISTRY_DOCKERHUB := tellllo

VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD) 
TARGETOS=linux #linux darwin windows
TARGETARCH=amd64 #amd64

# TARGETOS
# first word is the option of make command, and called like target parameter of makefile  
format:
# this command checks error in GO codeр
	gofmt -s -w ./

# lint shows style errors
lint: 
	golint

#command for execution automation testing of GO packages 
test:
	go test -v

# for getting GO packages 
get:
	go get 

# -v option for details
# -o option for creating file with name kbot
# added variables like GOOS and GOARCH.

build: format get
	CGO_ENABLED=0 GOOS=$(TARGETOS) GOARCH=$(TARGETARCH) go build -v -o kbot -ldflags "-X="github.com/Prometheus_3week_3module_5task/cmd.appVersion={VERSION}

#command for automation deleting  files that already don't needed. Like binary file of code after building doesn't need in commits history.

image:
	docker buildx build . -t ${REGISTRY}/${APP}:${VERSION} --platform=linux/amd64 --build-arg TARGETARCH=amd64


push:
	docker push ${REGISTRY}/${APP}:${VERSION}



clean:
	rm -rf kbot
