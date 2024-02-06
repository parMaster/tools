#!/bin/sh

set -e

# colors
red="\033[0;31m"
green="\033[0;32m"
cyan="\033[0;36m"
nc="\033[0m" # No Color

# setting variables
binaries="myip portmap"

main() {
	# setting paths
	installPath=${INSTALL_PATH:-$HOME/.tools}

	echo "Installing binaries $cyan($binaries)$nc to $installPath"

	# create the install directory
	mkdir -p "$installPath"

	# define the array of binaries to fetch/install
	for binary in $binaries; do
		cp "$binary" "$installPath/$binary" || {
			echo "$red Error: Unable to copy $binary to $installPath/$binary $nc"
			exit 1
		}
		chmod +x "$installPath/$binary" || {
			echo "$red Error: Unable to chmod +x $installPath/$binary $nc"
			exit 1
		}
		echo "$cyan $binary $nc was installed successfully to $green $installPath/$binary $nc"
	done

	case $SHELL in
	/bin/zsh) shell_profile=".zshrc" ;;
	*) shell_profile=".bash_profile" ;;
	esac

	# remove lines with TOOLS_INSTALL substring from the shell profile
	sed -i '/TOOLS_INSTALL/d' "$HOME/$shell_profile"
	
	echo ""
	echo "export TOOLS_INSTALL=\"$installPath\"" >> "$HOME/$shell_profile"
	echo "export PATH=\"\$TOOLS_INSTALL/bin:\$PATH\"" >> "$HOME/$shell_profile"
}

uninstall() {

	# setting paths
	installPath=${INSTALL_PATH:-$HOME/.tools}

	echo "Uninstalling binaries $red($binaries)$nc from $installPath"

	# define the array of binaries to fetch/install
	for binary in $binaries; do
		rm "$installPath/$binary" || {
			echo "$red Error: Unable to remove $installPath/$binary $nc"
			exit 1
		}
		echo "$red $binary $nc was uninstalled successfully from $green $installPath/$binary $nc"
	done

	case $SHELL in
	/bin/zsh) shell_profile=".zshrc" ;;
	*) shell_profile=".bash_profile" ;;
	esac

	# remove lines with TOOLS_INSTALL substring from the shell profile
	sed -i '/TOOLS_INSTALL/d' "$HOME/$shell_profile"
}

if [ "$1" = "uninstall" ]; then
	uninstall
else
	main
fi






















