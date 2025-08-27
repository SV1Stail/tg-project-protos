
PROTO_DIR=./proto
GO_OUT=./gen/go
PY_OUT=./gen/python

generate: generate-go generate-py

generate-go:
	rm -rf ${GO_OUT}/*
	find ${PROTO_DIR} -name "*.proto" -exec echo "Processing: {}" \; \
	-exec protoc -I "${PROTO_DIR}" --go_out="${GO_OUT}" --go-grpc_out="${GO_OUT}" {} \;

generate-py:
	rm -rf ${PY_OUT}/*
	find ${PROTO_DIR} -name "*.proto" -exec echo "Processing: {}" \; \
	-exec protoc -I "${PROTO_DIR}" \
		--python_out="${PY_OUT}" \
		--grpc_python_out="${PY_OUT}" \
		--plugin=protoc-gen-grpc_python=/usr/bin/grpc_python_plugin \
		{} \; 

	touch "${PY_OUT}/publisher/__init__.py"
	touch "${PY_OUT}/queue_scheduler/__init__.py" 

generated-clear:
	rm -rf ${PY_OUT}/*
	rm -rf ${GO_OUT}/*
