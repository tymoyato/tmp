#!/bin/bash

# Function to install Homebrew
install_homebrew() {
	if [[ "$OS" == "Linux" ]]; then
		# Install Homebrew on Linux
		printf "${YELLOW}Installing Homebrew on Linux...${NC}\n"
		yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		# Add Homebrew to the PATH
		printf "${YELLOW}Adding Homebrew to the PATH on Linux...${NC}\n"
		echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.bashrc
		source ~/.bashrc
	elif [[ "$OS" == "Darwin" ]]; then
		# Install Homebrew on macOS
		printf "${YELLOW}Installing Homebrew on macOS...${NC}\n"
		yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		# Add Homebrew to the PATH
		printf "${YELLOW}Adding Homebrew to the PATH on macOS...${NC}\n"
		echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.bashrc
		source ~/.bashrc
	else
		printf "${RED}Unsupported operating system: $OS${NC}\n"
		exit 1
	fi
}

# Check if Homebrew is already installed
printf "${YELLOW}Checking if Homebrew is already installed...${NC}\n"
if ! command -v brew &>/dev/null; then
	printf "${YELLOW}Homebrew is not installed. Installing Homebrew...${NC}\n"
	install_homebrew
else
	printf "${GREEN}Homebrew is already installed.${NC}\n"
	# Check if install_packages.sh exists
	if [[ -f packages.sh ]]; then
		# Run the script to install other packages
		printf "${YELLOW}Running the script to install other packages...${NC}\n"
		bash packages.sh
	else
		printf "${RED}Error: packages.sh not found.${NC}\n"
		exit 1
	fi
fi
