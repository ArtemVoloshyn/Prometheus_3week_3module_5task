# In general the purpose of this file is to get known the rules of how to correctly build project and for building automation process. 
# Make is a build automation tool used to manage the compilation and building of software projects. 
# It reads a Makefile, a file that specifies how to derive the target output files from source files, and executes the necessary commands to build the project.


APP := $(shell basename $(shell git remote get-url origin))
REGISTRY := voloshynartem

VERSION=$(shell echo -n $(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD))
#$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD) 

#TARGETOS=linux
#linux darwin windows
#TARGETARCH=amd64 	

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
	CGO_ENABLED=0 GOOS=$(TARGETOS) GOARCH=$(TARGETARCH) go build -v -o kbot -ldflags "-X="github.com/Prometheus_2week_2module_5task/cmd.appVersion=${VERSION}

#command for automation deleting  files that already don't needed. Like binary file of code after building doesn't need in commits history.

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}-${TARGETOS} --build-arg TARGETARCH=${TARGETARCH} --build-arg TARGETOS=${TARGETOS} 

docker_login:
	docker login -u ${REGISTRY}

push_docker_hub: docker_login
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}-${TARGETOS} 


################################1task - building GO execution program file #####

# targets with the name of OS are used to build app by go compiler 
# for different OS and architecture by predefining the OS and architecture parameter
# ?the command is instructing the build system to use the appropriate make command (represented by ${MAKE})
# to execute the build process targeting the Linux operating system and the x86-64 architecture.?
linux:
	${MAKE} build TARGETOS=linux TARGETARCH=amd64

arm:
	${MAKE} build TARGETOS=linux TARGETARCH=arm64

macOS:
	${MAKE} build TARGETOS=darwin TARGETARCH=arm64

windows:
	${MAKE} build TARGETOS=windws TARGETOS=amd64


####################2 task - building docker image   #####

# targets with the name of OS are used to build docker image with go compiler inside
# for different OS and architecture by predefining the OS and architecture parameter
image_linux: image
	TARGETOS=linux TARGETARCH=amd64
image_arm : image
	TARGETOS=linux TARGETARCH=arm64
image_macOS : image
	TARGETOS=darwin TARGETARCH=arm64
image_windows : image
	TARGETOS=windws TARGETOS=amd64


################commands for authorization in containers registry########
gcloud_login:
	docker login -u oauth2accesstoken -p "$(gcloud auth print-access-token)" https://gcr.io 
	

push_gcloud: gcloud_login
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}-${TARGETOS} 




############################3 task - clearing #####
#add cleaner for cleaning docker images by tags and GO executable task

clean:
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}-${TARGETOS} 

clean.all: 
	rm -rf kbot
