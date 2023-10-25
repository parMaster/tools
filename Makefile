RED=\033[1;31m
CYAN=\033[1;36m
NC=\033[0m

.PHONY: build

build:
	@echo "Building $(CYAN)mmyip$(NC)..."
	go build ./cmd/myip
	@echo "Building $(CYAN)portmap$(NC)..."
	go build ./cmd/portmap


install: build
	@echo "Installing $(CYAN)mmyip$(NC)..."
	@cp -n myip ${GOPATH}/bin && echo "$(CYAN)mmyip$(NC) has been installed." || echo "$(CYAN)mmyip$(NC) is already installed."
	@echo "Installing $(CYAN)portmap$(NC)..."
	@cp -n portmap ${GOPATH}/bin && echo "$(CYAN)portmap$(NC) has been installed." || echo "$(CYAN)portmap$(NC) is already installed."

clean:
	@echo "Cleaning..."
	@rm ${GOPATH}/bin/myip && echo "$(RED)mmyip$(NC) has been removed." || echo "$(RED)mmyip$(NC) is not installed."
	@rm ${GOPATH}/bin/portmap && echo "$(RED)portmap$(NC) has been removed." || echo "$(RED)portmap$(NC) is not installed."

.DEFAULT_GOAL: build