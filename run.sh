#!/usr/bin/env bash

clear

usage() {
  echo "Использование: $0 [-h] [-p] [-g] []"
  echo
  echo "  -h    Показать помощь"
  echo "  -p    скачать protoc для python"
  echo "  -g    скачать protoc для go"
  echo "  -n    Указать число"
}

while getopts "hpg" OPTS; do
case $OPTS in
    h)
        usage
        exit 0
    ;;
    p)
        if ! python -m grpc_tools.protoc --version &>/dev/null; then
            pip install grpcio-tools
        fi

    ;;
    g)
        if ! command -v protoc &>/dev/null; then
            go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
            go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
            echo "check your protoc!!!"
        fi
        # generate_go
        protoc -I "./" --go_out="./gen/go/" --go-grpc_out="./gen/go/" "proto/queue_scheduler/*.proto" "proto/publisher/*.proto"
    ;;
    \?)
        exit 0
    ;;
esac
done

PROTO_DIR="./"
GO_OUT="./gen/go"
PY_PKG_DIR="./gen/python"
