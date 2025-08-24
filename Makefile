
PROTO_DIR=proto
GO_OUT=gen/go
PY_PKG_DIR=gen/python

generate: generate-go

generate-go:
	@mkdir -p $(GO_OUT)/queue_scheduler $(GO_OUT)/publisher
	protoc -I $(PROTO_DIR) \
	  --go_out=$(GO_OUT) --go-grpc_out=$(GO_OUT) \
	  $(PROTO_DIR)/queue_scheduler/*.proto \
	  $(PROTO_DIR)/publisher/publisher.proto
	@echo "✅ Go generated"

