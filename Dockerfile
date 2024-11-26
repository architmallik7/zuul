FROM ubuntu:bionic as base-builder

ENV ANURAG=test
ENV GOPATH=$HOME/go
ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

RUN apt-get update && apt-get install -y \
    curl git build-essential cmake wget unzip libssl-dev zlib1g-dev \
    && apt-get clean

FROM base-builder as golang
RUN curl -O https://storage.googleapis.com/golang/go1.15.2.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.15.2.linux-amd64.tar.gz \
    && rm go1.15.2.linux-amd64.tar.gz

FROM base-builder as source-code
RUN git clone https://github.com/prometheus/prometheus.git prometheus

FROM base-builder as builder
COPY --from=golang /usr/local/go /usr/local/go
COPY --from=source-code prometheus/ prometheus/
RUN cd prometheus && echo "Change" > change.txt

# Install Python in the same layer
RUN cd /tmp \
    && wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz \
    && tar -xzf Python-3.8.0.tgz \
    && cd Python-3.8.0 \
    && ./configure \
    && make \
    && make install \
    && rm -rf /tmp/Python-3.8.0*

FROM ubuntu:bionic as final
COPY --from=builder prometheus/change.txt change.txt
