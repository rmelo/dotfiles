#!/usr/bin/env bash
set -e

DOTFILES_REPO="https://github.com/rmelo/dotfiles.git"
CHEZMOI_CONFIG="$HOME/.config/chezmoi/chezmoi.yaml"

# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────
info()    { printf "\033[1;34m→\033[0m %s\n" "$1"; }
success() { printf "\033[1;32m✓\033[0m %s\n" "$1"; }
warn()    { printf "\033[1;33m!\033[0m %s\n" "$1"; }

# ─────────────────────────────────────────────
# 1. Homebrew (macOS only)
# ─────────────────────────────────────────────
if [[ "$(uname)" == "Darwin" ]]; then
  if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add brew to PATH for the rest of this script
    eval "$(/opt/homebrew/bin/brew shellenv)"
    success "Homebrew installed"
  else
    success "Homebrew already installed"
  fi
fi

# ─────────────────────────────────────────────
# 2. Git
# ─────────────────────────────────────────────
if ! command -v git &>/dev/null; then
  info "Installing git..."
  if [[ "$(uname)" == "Darwin" ]]; then
    brew install git
  else
    sudo dnf install -y git
  fi
  success "git installed"
else
  success "git already installed"
fi

# ─────────────────────────────────────────────
# 3. Ansible (also installs python3 on Fedora as dependency)
# ─────────────────────────────────────────────
if ! command -v ansible &>/dev/null; then
  info "Installing Ansible..."
  if [[ "$(uname)" == "Darwin" ]]; then
    brew install ansible
  else
    sudo dnf install -y ansible
  fi
  success "Ansible installed"
else
  success "Ansible already installed"
fi

# ─────────────────────────────────────────────
# 3. chezmoi
# ─────────────────────────────────────────────
if ! command -v chezmoi &>/dev/null; then
  info "Installing chezmoi..."
  sh -c "$(curl -fsLS get.chezmoi.io)"
  # chezmoi installs to ~/.local/bin by default
  export PATH="$HOME/.local/bin:$PATH"
  success "chezmoi installed"
else
  success "chezmoi already installed"
fi

# ─────────────────────────────────────────────
# 4. chezmoi.yaml config
# ─────────────────────────────────────────────
if [[ ! -f "$CHEZMOI_CONFIG" ]]; then
  info "Creating chezmoi config at $CHEZMOI_CONFIG"
  mkdir -p "$(dirname "$CHEZMOI_CONFIG")"

  read -rp "  Full name (for git config): " USER_NAME
  read -rp "  Email (for git config): "     USER_EMAIL
  read -rp "  SSH signing key (public key, for git commit signing — leave blank to skip): " SSH_SIGNING_KEY

  cat > "$CHEZMOI_CONFIG" <<EOF
data:
  name: "${USER_NAME}"
  email: "${USER_EMAIL}"
  git:
    sshSigningKey: "${SSH_SIGNING_KEY}"
EOF
  success "chezmoi config written"
else
  success "chezmoi config already exists, skipping"
fi

# ─────────────────────────────────────────────
# 5. chezmoi init + apply
# ─────────────────────────────────────────────
CHEZMOI_SOURCE="$HOME/.local/share/chezmoi"

if [[ ! -d "$CHEZMOI_SOURCE/.git" ]]; then
  info "Initializing chezmoi from $DOTFILES_REPO ..."
  chezmoi init "$DOTFILES_REPO"
  success "chezmoi initialized"
else
  info "chezmoi source dir already exists, pulling latest..."
  git -C "$CHEZMOI_SOURCE" pull
  success "chezmoi source updated"
fi

info "Applying dotfiles..."
chezmoi apply
success "Dotfiles applied"

# ─────────────────────────────────────────────
# 6. Ansible provisioning
# ─────────────────────────────────────────────
info "Running Ansible playbook (you may be asked for your sudo password)..."
cd "$CHEZMOI_SOURCE/ansible"
ansible-playbook setup.yml --ask-become-pass
success "Ansible provisioning done"

# ─────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────
printf "\n\033[1;32mAll done!\033[0m\n"
printf "Tip: switch chezmoi remote to SSH once your keys are set up:\n"
printf "  cd ~/.local/share/chezmoi && git remote set-url origin git@github.com:rmelo/dotfiles.git\n\n"
