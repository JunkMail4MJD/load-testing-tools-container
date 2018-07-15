FROM ubuntu:16.04 AS wrk-build

WORKDIR /usr/src
RUN apt-get update -y
RUN apt-get install build-essential libssl-dev git -y
RUN git clone https://github.com/wg/wrk.git wrk

WORKDIR /usr/src/wrk
RUN make

WORKDIR /usr/src
RUN git clone https://github.com/giltene/wrk2.git
WORKDIR /usr/src/wrk2
RUN make

# -------------------
FROM golang:1.10 AS go-build

WORKDIR /go/src
RUN go get -u github.com/rakyll/hey
WORKDIR /go/src/github.com/rakyll/hey/
RUN go install


# -------------------
FROM ubuntu:16.04 AS release
WORKDIR /usr/src
RUN apt-get update -y
RUN apt-get install libssl1.0.0 -y
COPY --from=wrk-build /usr/src/wrk/wrk .
COPY --from=wrk-build /usr/src/wrk2/wrk wrk2
COPY --from=go-build /go/bin/hey .

CMD /bin/bash
