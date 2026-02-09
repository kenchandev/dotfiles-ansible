#!/usr/bin/env bash

set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
HOMEBREW_BIN_DIR=/opt/homebrew/bin
PYTHON_LATEST_STABLE_VERSION=3.13

print_info() {
  printf "\r  [ \033[00;34m...\033[0m ] %s\n" "$1"
}

print_success() {
  printf "\r\033[2K  [ \033[00;32mSUCCESS\033[0m ] %s\n" "$1"
}

print_fail() {
  printf "\r\033[2K  [ \033[0;31mFAIL\033[0m ] %s\n" "$1"
}

# Adding indentation in front of EOD raises syntax error: unexpected end of file.
install_xcode_cli_tools() {
  if xcode-select -p > /dev/null; then
    printf "[ \033[00;34m...\033[0m ] XCode Command Line Tools already installed.\n"
  else
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
    XCODE_COMMAND_LINE_TOOLS=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')
    softwareupdate -i "$XCODE_COMMAND_LINE_TOOLS" --verbose
    rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  fi
}

install_homebrew() {
  if ! [[ $(which $HOMEBREW_BIN_DIR/brew) ]]; then
    printf "[ \033[00;34m...\033[0m ] Installing Homebrew...\n"
    # Bypass the installer abruptly halting on "Press RETURN."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    printf "[ \033[00;34m...\033[0m ] Homebrew already installed.\n"
    return
  fi
}

install_uv() {
  install_homebrew

  if ! [[ $(which $HOMEBREW_BIN_DIR/uv) ]]; then
    printf "[ \033[00;34m...\033[0m ] Installing uv...\n"
    $HOMEBREW_BIN_DIR/brew install uv
  else
    printf "[ \033[00;34m...\033[0m ] uv already installed.\n"
    return
  fi
}

install_python() {
  install_uv

  if ! [[ -f $HOME/.local/bin/python$PYTHON_LATEST_STABLE_VERSION ]]; then
    $HOMEBREW_BIN_DIR/uv python install $PYTHON_LATEST_STABLE_VERSION
  else
    printf "[ \033[00;34m...\033[0m ] Latest Python version already installed.\n"
    return
  fi
}

install_ansible() {
  install_homebrew
  initialize_venv

  if ! [[ -f $HOME/.venv/bin/ansible ]]; then
    printf "[ \033[00;34m...\033[0m ] Installing Ansible...\n"
    $HOMEBREW_BIN_DIR/uv pip install ansible
  else
    printf "[ \033[00;34m...\033[0m ] Ansible already installed.\n"
    return
  fi
}

initialize_ansible_venv() {
  if ! [[ -d $HOME/.venv ]]; then
    printf "[ \033[00;34m...\033[0m ] Initializing virtual environment for Ansible...\n"
    $HOMEBREW_BIN_DIR/uv venv -p $PYTHON_LATEST_STABLE_VERSION $HOME/.venv
  else
    printf "[ \033[00;34m...\033[0m ] Virtual environment for Ansible already initialized.\n"
  fi

  # shellcheck source=/dev/null
  source $HOME/.venv/bin/activate

  $HOMEBREW_BIN_DIR/uv pip install pexpect
}

deactivate_ansible_venv() {
  deactivate
}

run_ansible_playbook() {
  printf "[ \033[00;34m...\033[0m ] Installing collections with Ansible Galaxy...\n"
  $HOMEBREW_BIN_DIR/uv run ansible-galaxy install -r requirements.yml

  # "xcode" is listed first to ensure the Xcode license agreement has been accepted.
  # Homebrew fails to run if the Xcode license agreement has not yet been accepted.
  tags=("xcode" "homebrew" "mas" "xcode" "git" "ssh" "install")

  for tag in "${tags[@]}"; do
    echo "Running Ansible playbook for tag: $tag"

    if $HOMEBREW_BIN_DIR/uv run ansible-playbook -v -i "${ROOT_DIR}/hosts" "${ROOT_DIR}/local_env.yml" --tags "$tag"; then
      echo "Successfully completed playbook for tag: $tag"
    else
      echo "Error running playbook for tag: $tag"
    fi
  done

  echo "All playbooks completed."
}

sudo --validate

install_xcode_cli_tools
install_homebrew
install_uv
install_python
initialize_ansible_venv
install_ansible
run_ansible_playbook
deactivate_ansible_venv