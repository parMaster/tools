RED=\033[1;31m
CYAN=\033[1;36m
NC=\033[0m

INSTALL_PATH=/usr/local/sbin

.PHONY: build, install, uninstall

build:
	@echo "Building $(CYAN)myip$(NC)..."
	go build ./cmd/myip
	@echo "Building $(CYAN)portmap$(NC)..."
	go build ./cmd/portmap

install: build
	@echo "Installing binaries to $(CYAN)${INSTALL_PATH}$(NC)..."
	@echo "Installing $(CYAN)myip$(NC)..."
	@sudo cp myip ${INSTALL_PATH} && echo "$(CYAN)myip$(NC) has been installed."
	@echo "Installing $(CYAN)portmap$(NC)..."
	@sudo cp portmap ${INSTALL_PATH} && echo "$(CYAN)portmap$(NC) has been installed."

uninstall:
	@echo "Uninstalling binaries..."
	@sudo rm ${INSTALL_PATH}/myip && echo "$(RED)myip$(NC) has been removed." || echo "$(RED)myip$(NC) is not installed."
	@sudo rm ${INSTALL_PATH}/portmap && echo "$(RED)portmap$(NC) has been removed." || echo "$(RED)portmap$(NC) is not installed."
