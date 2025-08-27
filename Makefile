
PROTO_DIR=./
GO_OUT=./gen/go
PY_PKG_DIR=gen/python

generate: generate-go

generate-go:
	find ${PROTO_DIR} -name "*.proto" -exec echo "Processing: {}" \; \
	-exec protoc -I "${PROTO_DIR}" --go_out="${GO_OUT}" --go-grpc_out="${GO_OUT}" {} \;

