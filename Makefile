GOPATH=$(shell go env GOPATH)

RED=\033[1;31m
CYAN=\033[1;36m
NC=\033[0m

.PHONY: build, install, uninstall

build:
	@echo "Building $(CYAN)myip$(NC)..."
	go build ./cmd/myip
	@echo "Building $(CYAN)portmap$(NC)..."
	go build ./cmd/portmap

install:
	go install ./cmd/portmap
	go install ./cmd/myip

uninstall:
	rm $(GOPATH)/bin/portmap
	rm $(GOPATH)/bin/myip
