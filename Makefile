RED=\033[1;31m
CYAN=\033[1;36m
NC=\033[0m

# INSTALL_PATH=/usr/local/sbin

.PHONY: build, install, uninstall

build:
	@echo "Building $(CYAN)myip$(NC)..."
	go build ./cmd/myip
	@echo "Building $(CYAN)portmap$(NC)..."
	go build ./cmd/portmap

install: build
	@echo ""
	@sh ./install.sh install

uninstall:
	@echo ""
	@sh install.sh uninstall
