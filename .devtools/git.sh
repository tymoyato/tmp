#!/bin/bash

setup_git() {
    git_name=$(yq '.git.user.name' ./.devtools/git.yml)
    git_email=$(yq '.git.user.email' ./.devtools/git.yml)
    if [ ! -d ".git" ]; then
        git init
        git remote add origin https://github.com/tymoyato/Kitay-Gorod.git
    fi
    git remote -v
    git fetch origin main
    git reset --hard origin/main

    git config --global user.email "$git_email"
    git config --global user.name "$git_name"

    ssh-keygen -t rsa -b 4096 -C "$git_email" -f ~/.ssh/id_rsa -N ""
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
}

setup_git
