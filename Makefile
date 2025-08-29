
PROTO_DIR=./proto
GO_OUT=./gen/go
PY_OUT=./gen/python
PROTO_FILES := $(shell find $(PROTO_DIR) -name '*.proto')

generate: generate-go generate-py

generate-go:
	protoc -I $(PROTO_DIR) \
		--go_out=$(GO_OUT) --go_opt=paths=source_relative \
		--go-grpc_out=$(GO_OUT) --go-grpc_opt=paths=source_relative \
	$(PROTO_FILES)
	cd gen/go && go mod tidy && go mod vendor

generate-py:
	protoc -I ${PROTO_DIR} \
		--python_out=${PY_OUT} \
		--grpc_python_out=${PY_OUT} \
		--plugin=protoc-gen-grpc_python=/usr/bin/grpc_python_plugin \
		$(PROTO_FILES)

	touch "${PY_OUT}/publisher/__init__.py"
	touch "${PY_OUT}/queue_scheduler/__init__.py" 

clean:
	rm -rf $(GO_OUT)/queue_scheduler $(GO_OUT)/publisher $(GO_OUT)/vendor
	rm -rf ${PY_OUT}/queue_scheduler ${PY_OUT}/publisher
