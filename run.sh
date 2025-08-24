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

while getopts "" OPTS; do
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

generate_py () {
    echo "Generating Python"
    mkdir -p "${PY_PKG_DIR}" "${PY_PKG_DIR}"
    # python -m grpc_tools.protoc -I "${PROTO_DIR}" \
    # --python_out="${PY_PKG_DIR}" --grpc_python_out="${PY_PKG_DIR}" \
    # "${PROTO_DIR}/scheduler/queue_scheduler.proto" \
    # "${PROTO_DIR}/publisher/publisher.proto"

    # touch "${PY_PKG_DIR}/__init__.py"
    # touch "${PY_PKG_DIR}/scheduler/__init__.py"
    # touch "${PY_PKG_DIR}/publisher/__init__.py"
}

generate_go () {
    mkdir -p "${GO_OUT}" "${GO_OUT}"
    echo "Generating GO"
    # protoc -I "${PROTO_DIR}" \
    #     --go_out="${GO_OUT}/queue_scheduler" --go-grpc_out="${GO_OUT}" \
    #     "${PROTO_DIR}/queue_scheduler/*.proto" 
    # protoc -I "${PROTO_DIR}" \
    #     --go_out="${GO_OUT}" --go-grpc_out="${GO_OUT}" \
    #     "${PROTO_DIR}/publisher/publisher.proto"
}

