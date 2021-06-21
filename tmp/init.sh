#!/bin/bash
#
# Type: Script Shell Installer
# Description: Simple script Management.
#
#
# Supported: Unix
# Release State: 1.0.2
# Script Name: init.sh

# Author: William C. Canin
#   E-Mail: william.costa.canin@gmail.com
#   Home page: https://williamcanin.me

# License:
# The MIT License (MIT)

# Copyright (c) 2019 William C. Canin <william.costa.canin@gmail.com>

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ******************************************************************************
#
# Note: Not use with root.
# Usage: bash init.sh help
#

# Global variables
VENDOR_PATH="vendor"

# Import
source "./_deploy.conf"

# Function color message
function msg_header() {
    printf "$(tput setaf 38)→ %s$(tput sgr0)\n" "$1"
}

function msg_finish() {
    printf "$(tput setaf 76)✔ %s$(tput sgr0)\n" "$1"
}

function msg_warning() {
    printf "$(tput setaf 3)⚠ %s$(tput sgr0)\n" "$@"
}

function msg_error() {
    printf "$(tput setaf 1)✖ %s$(tput sgr0)\n" "$@"
}

function msg_li() {
    printf "$(tput setaf 3)* %s$(tput sgr0)\n" "$@"
}

# Verify exists .git
function _add_repo_git(){
  if [[ ! -d "./.git" ]]; then
    git init
  fi
}

# Function to capture Jekyll's build folder.
function _get_destination(){
  if [[ -f "$1" ]]; then
   destination_build="$(cat "$1" | grep destination | cut -d':' -f2 | cut -d' ' -f2)"
  fi
}

# Function add/verify remote url
function _add_remoteurl(){
  rem_verify="$(sed -n '/url/p' .git/config | cut -d'=' -f2 | cut -d' ' -f2)"
  if [[ ! -n $rem_verify ]]; then
    git remote add origin $remoteURL
  fi
}

# Enter a specific folder
function _enter_folder(){
  if [[ -d "$1" ]]; then
    cd $1
  fi
}

# Function execute pull before push
function _pull_execute(){
  if [[ $pull == "yes" ]]; then
    git pull origin $1
  fi
}

# Function get branch for create checkout or no
function _git_checkout(){
  branch_get="$(git branch --list | sed -n "/$1/p" | cut -d'*' -f2 | awk '{ gsub (" ", "", $0); print}')"
  if [[ -z $branch_get ]]; then
    git checkout -b $1
  else
    git checkout $branch_get
  fi
}

# Function build project and deploy project build
function _deploy_site(){

  if [[ $compile == "yes" ]]; then
    JEKYLL_ENV=production bundle exec jekyll b
  fi

  _get_destination "_config.yml"
  _enter_folder $destination_build
  _add_repo_git
  _add_remoteurl
  _pull_execute $built
  msg_header "Deploy source files. Wait ..."
  _git_checkout $built
  git add .
  git  commit -m "$commit - $(date)"
  git push origin -u $built
  msg_finish "Done!"
}

# Function start deploy source files
function _deploy_source(){
  _add_repo_git
  _add_remoteurl
  _pull_execute $source
  _git_checkout $source
  msg_header "Deploy source files. Wait ..."
  git add .
  git  commit -m "$commit - $(date)"
  git push origin -u $source
  msg_finish "Done!"
}

if [[ ! -f $(which yarn) ]] && [[ ! -f $(which gem) ]]; then
  msg_error "Install 'yarn' and 'gem'. Aborted!"
  exit 1
fi

# Menu
case $1 in
  install )
    rm -f Gemfile.lock yarn.lock
    gem install bundler --pre
    yarn install
    msg_finish "Done!"
  ;;
  serve )
      yarn serve
      msg_finish "Done!"
    ;;
  build )
      yarn build
      msg_finish "Done!"
    ;;
  post)
    if [[ ! -f "$(ls $VENDOR_PATH/bundle/ruby/*/bin/rake)" ]]; then
      msg_warning "You need Rake to continue. Install the project dependencies first."
      msg_warning "Command: $0 install"
      exit 1
    else
      bundle exec rake post
    fi
    ;;
    page)
      if [[ ! -f "$(ls $VENDOR_PATH/bundle/ruby/*/bin/rake)" ]]; then
        msg_warning "You need Rake to continue. Install the project dependencies first."
        msg_warning "Command: $0 install"
        exit 1
      else
        bundle exec rake page
      fi
      ;;
  reset)
    msg_header "Reset all the pure settings. Wait ..."
    rm -rf ".git"
    rm -rf "Gemfile.lock" "yarn.lock"
    rm -rf "$VENDOR_PATH"
    _get_destination "_config.yml"
    rm -rf "$destination_build"
    msg_finish "Done!"
  ;;
  deploy:source)
    _deploy_source
  ;;
  deploy:site)
    _deploy_site
  ;;
  *|help)
     msg_warning "Usage: $0 { install | build | serve | post | page | deploy:source | deploy:site | reset }"
  ;;
esac

# END
