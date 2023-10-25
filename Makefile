RED=\033[1;31m
CYAN=\033[1;36m
NC=\033[0m

.PHONY: build

build:
	@echo "Building $(CYAN)mmyip$(NC)..."
	go build ./cmd/myip

install: build
	@echo "Installing $(CYAN)mmyip$(NC)..."
	@cp -n myip ${GOPATH}/bin && echo "$(CYAN)mmyip$(NC) has been installed." || echo "$(CYAN)mmyip$(NC) is already installed."

clean:
	@echo "Cleaning..."
	@rm ${GOPATH}/bin/myip && echo "$(RED)mmyip$(NC) has been removed." || echo "$(RED)mmyip$(NC) is not installed."

.DEFAULT_GOAL: build