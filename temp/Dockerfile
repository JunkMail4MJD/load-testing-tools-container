FROM golang:1.10 AS wrk-build

WORKDIR /go/src
RUN go get -u github.com/rakyll/hey
WORKDIR /go/src/github.com/rakyll/hey/
RUN go install
CMD /bin/bash
