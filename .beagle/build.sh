#!/bin/bash 

set -ex

mkdir -p dist

export GOARCH=amd64
make build-go
mv bin/linux-$GOARCH/grafana-server dist/grafana-server-linux-$GOARCH
mv bin/linux-$GOARCH/grafana-cli dist/grafana-cli-linux-$GOARCH

export GOARCH=arm64
export CC=aarch64-linux-gnu-gcc
make build-go
mv bin/linux-$GOARCH/grafana-server dist/grafana-server-linux-$GOARCH
mv bin/linux-$GOARCH/grafana-cli dist/grafana-cli-linux-$GOARCH

export GOARCH=ppc64le
export CC=powerpc64le-linux-gnu-gcc
make build-go
mv bin/linux-$GOARCH/grafana-server dist/grafana-server-linux-$GOARCH
mv bin/linux-$GOARCH/grafana-cli dist/grafana-cli-linux-$GOARCH

export GOARCH=mips64le
export GIT_SHA=$(git rev-parse HEAD)
export GIT_CLOSEST_TAG=$(git describe --abbrev=0 --tags)
export GIT_Branch=$(git rev-parse --abbrev-ref HEAD)
export DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')

CC=mips64el-linux-gnuabi64-gcc \
CGO_ENABLED=1 \
go build \
-ldflags \
"-X main.version=$GIT_CLOSEST_TAG \
-X main.commit=$GIT_SHA \
-X main.buildstamp=$DATE \
-X main.buildBranch=$GIT_Branch" \
-o ./bin/linux-mips64le/grafana-cli \
./pkg/cmd/grafana-cli

CC=mips64el-linux-gnuabi64-gcc \
CGO_ENABLED=1 \
go build \
-ldflags \
"-X main.version=$GIT_CLOSEST_TAG \
-X main.commit=$GIT_SHA \
-X main.buildstamp=$DATE \
-X main.buildBranch=$GIT_Branch" \
-o ./bin/linux-mips64le/grafana-server \
./pkg/cmd/grafana-server

mv bin/linux-$GOARCH/grafana-server dist/grafana-server-linux-$GOARCH
mv bin/linux-$GOARCH/grafana-cli dist/grafana-cli-linux-$GOARCH