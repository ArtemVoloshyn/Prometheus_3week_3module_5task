#putting the go compiler inside container for building process  
FROM quay.io/projectquay/golang:1.20 as builder

WORKDIR /go/src/app
#will copy output code to the build contex
COPY . .
#ARG TARGETARCH
#ARG TARGETOS
RUN make build TARGETARCH=$TARGETARCH TARGETOS=$TARGETOS

#TARGETARCH=$TARGETARCH

FROM scratch
WORKDIR /
#copy artefact from building place, where GO installed
COPY --from=builder /go/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt/ /etc/ssl/certs
ENTRYPOINT ["./kbot"]

