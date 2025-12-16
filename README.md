# Rodrigo’s Dotfiles

This repository contains my personal dotfiles, managed with **chezmoi**.  
It supports **macOS** and **Fedora Linux**.

---

## Requirements

- git
- chezmoi
- GitHub Personal Access Token (PAT) for the first setup

---

## 1. Install chezmoi

Follow the official instructions:  
https://www.chezmoi.io/install/

Verify:

```bash
chezmoi --version
```
## 2. First-time setup (no SSH yet)

Initialize chezmoi using HTTPS:

```bash
chezmoi init https://github.com/rmelo/dotfiles.git
```

When prompted by GitHub:

Username → your GitHub username

Password → GitHub Personal Access Token

Apply the dotfiles:

```bash
chezmoi apply
```

## 3. Configure local variables

Create the local chezmoi config file:

```bash
mkdir -p ~/.config/chezmoi
vim ~/.config/chezmoi/chezmoi.yaml
```

Example:

```yaml
data:
  name: "Your name"
  email: "Your git email"
  git:
    sshSigningKey: "Your signin key"
```
⚠️ This file is local only and must not be committed.

### Apply again:

```bash
chezmoi apply
```

## 4. Switch repository to SSH (recommended)

After SSH keys are installed by the dotfiles:

```bash
cd ~/.local/share/chezmoi
git remote set-url origin git@github.com:rmelo/dotfiles.git
```

From now on, updates will use SSH.

## 5. Update dotfiles

```bash
chezmoi update
```

Useful commands
```bash
chezmoi diff     # Preview changes
chezmoi apply    # Apply changes
chezmoi doctor   # Validate setup
```
