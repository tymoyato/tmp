#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Detect the operating system
printf "${YELLOW}Detecting the operating system...${NC}\n"
OS=$(uname -s)

# Function to install git
install_git() {
    # Check if git is installed on Linux
    printf "${YELLOW}Checking if git is installed on Linux...${NC}\n"
    if ! command -v git &> /dev/null
    then
        printf "${YELLOW}git is not installed. Installing git...${NC}\n"
        sudo apt-get update
        sudo apt-get install -y git
    else
        printf "${GREEN}git is already installed.${NC}\n"
    fi
}
# Function to install curl
install_curl() {
    # Check if curl is installed
    printf "${YELLOW}Checking if curl is installed...${NC}\n"
    if ! command -v curl &> /dev/null
    then
        printf "${YELLOW}curl is not installed. Installing curl...${NC}\n"
        if [[ "$OS" == "Linux" ]]; then
            sudo apt-get update
            sudo apt-get install -y curl
        elif [[ "$OS" == "Darwin" ]]; then
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            brew install curl
        else
            printf "${RED}Unsupported operating system: $(uname -s)${NC}\n"
            exit 1
        fi
    else
        printf "${GREEN}curl is already installed.${NC}\n"
    fi
}
# Check if the user is in the sudoers file
check_sudo() {
    printf "${YELLOW}Checking if the user has sudo privileges...${NC}\n"
    if ! sudo -n true 2>/dev/null; then
        printf "${YELLOW}User does not have sudo privileges. Adding user to sudoers...${NC}\n"
        if [[ "$OS" == "Linux" ]]; then
            sudo_user=$(whoami)
            sudo_command="echo '$sudo_user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"
            su -c "$sudo_command"
        else
            printf "${RED}Unsupported operating system for adding sudo privileges: ${OS}${NC}\n"
            exit 1
        fi
    else
        printf "${GREEN}User has sudo privileges.${NC}\n"
    fi
}
# Function to install Homebrew
install_homebrew() {
    if [[ "$OS" == "Linux" ]]; then
        # Install Homebrew on Linux
        printf "${YELLOW}Installing Homebrew on Linux...${NC}\n"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Add Homebrew to the PATH
        printf "${YELLOW}Adding Homebrew to the PATH on Linux...${NC}\n"
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
        source ~/.bashrc
    elif [[ "$OS" == "Darwin" ]]; then
        # Install Homebrew on macOS
        printf "${YELLOW}Installing Homebrew on macOS...${NC}\n"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Add Homebrew to the PATH
        printf "${YELLOW}Adding Homebrew to the PATH on macOS...${NC}\n"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bashrc
        source ~/.bashrc
    else
        printf "${RED}Unsupported operating system: $OS${NC}\n"
        exit 1
    fi
}

install_git
install_curl
check_sudo
# Check if Homebrew is already installed
printf "${YELLOW}Checking if Homebrew is already installed...${NC}\n"
if ! command -v brew &> /dev/null
then
    printf "${YELLOW}Homebrew is not installed. Installing Homebrew...${NC}\n"
    install_homebrew
else
    printf "${GREEN}Homebrew is already installed.${NC}\n"
    # Check if install_packages.sh exists
    if [[ -f install_packages.sh ]]; then
        # Run the script to install other packages
        printf "${YELLOW}Running the script to install other packages...${NC}\n"
        bash install_packages.sh
    else
        printf "${RED}Error: install_packages.sh not found.${NC}\n"
        exit 1
    fi
fi

# Function to check if Homebrew is installed
check_brew_installed() {
    if command -v brew &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Check if Homebrew is installed
if ! check_brew_installed; then
    printf "${YELLOW}Homebrew is not installed. Please install Homebrew first.${NC}\n"
    exit 1
else
    # Ensure the PATH is correctly set
    printf "${YELLOW}Ensuring the PATH is correctly set...${NC}\n"
    if [[ "$OS" == "Linux" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [[ "$OS" == "Darwin" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    # Verify Homebrew installation
    printf "${YELLOW}Verifying Homebrew installation...${NC}\n"
    brew --version
fi
source ~/.bashrc

# Function to install packages with brew
install_packages_with_brew() {
    printf "${YELLOW}Installing packages with Homebrew...${NC}\n"
    for package in "$@"; do
        printf "${YELLOW}Installing $package...${NC}\n"
        brew install "$package"
    done
    printf "${GREEN}All packages installed successfully.${NC}\n"
}

install_packages_with_brew rbenv nvm
