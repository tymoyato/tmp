#!/bin/bash

# Make each script executable
chmod +x os.sh
chmod +x sudo.sh
chmod +x linux.sh
chmod +x fonts.sh

# Run os.sh
./os.sh

# Run install.sh
./linux.sh

# Run sudo.sh
./sudo.sh

# Source .bashrc
source ~/.bashrc

# Run fonts.sh
./fonts.sh

# Run homebrew.sh
./homebrew.sh