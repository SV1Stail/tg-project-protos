PROTO_DIR := proto
GO_OUT := gen/go
PY_OUT := gen/python
PROTOC_IMAGE := proto-generator:local
PROTO_FILES := $(shell find $(PROTO_DIR) -type f -name '*.proto')
UID_GID := $(shell id -u):$(shell id -g)

.PHONY: build-protoc-image generate generate-go generate-py clean

all: build-protoc-image generate

build-protoc-image:
	docker build -t $(PROTOC_IMAGE) -f docker/protoc/Dockerfile .

generate: generate-go

generate-go:
	mkdir -p $(GO_OUT)
	docker run --rm \
		--user $(UID_GID) \
		-v "$(CURDIR):/workspace" \
		-w /workspace \
		$(PROTOC_IMAGE) \
		protoc \
		-I $(PROTO_DIR) \
		--go_out=$(GO_OUT) --go_opt=paths=source_relative \
		--go-grpc_out=$(GO_OUT) --go-grpc_opt=paths=source_relative \
		$(PROTO_FILES)
	cd $(GO_OUT) && go mod tidy && go mod vendor

generate-py:
	mkdir -p $(PY_OUT)
	docker run --rm \
		--user $(UID_GID) \
		-v "$(CURDIR):/workspace" \
		-w /workspace \
		$(PROTOC_IMAGE) \
		python3 -m grpc_tools.protoc \
		-I $(PROTO_DIR) \
		--python_out=$(PY_OUT) \
		--grpc_python_out=$(PY_OUT) \
		$(PROTO_FILES)

clean:
	rm -rf $(GO_OUT) $(PY_OUT)