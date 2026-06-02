# docker/protoc/Dockerfile
FROM golang:bookworm

RUN apt-get update && apt-get install -y \
    protobuf-compiler \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

RUN python3 -m pip install --break-system-packages grpcio-tools

ENV PATH="/go/bin:${PATH}"

WORKDIR /workspace