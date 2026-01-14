# Using 1Password SSH Agent with Chezmoi

This guide explains how to create an SSH key in 1Password, enable it as an SSH agent, and configure chezmoi to work with it.

## 1. Create the SSH key in 1Password

1. Open 1Password
2. Click New Item
3. Choose SSH Key
4. Fill:
- Title: GitHub SSH Key
- Vault: your main/private vault
- Key type: ed25519 (recommended)
5. Save it!

1Password now securely stores: private key, public key and fingerprint.

## 2. Add the public key to GitHub

1. In 1Password, open the SSH key
2. Copy the public key
3. Go to GitHub: [https://github.com/settings/ssh/new](https://github.com/settings/ssh/new)
4. Paste the public key
5. Title example: My Personal SSH (1P)

## 3. Enable 1Password SSH Agent

### On MacOS

1. Open 1Password → Settings
2. Go to Developer
3. Enable:
- ✅ Use the SSH agent
- ✅ Integrate with 1Password CLI
4. Restart your terminal.

### Fedora / Linux

1. Install 1Password CLI (op)
2. Enable SSH agent:
3. export SSH_AUTH_SOCK=~/.1password/agent.sock
4. (Optional) Add this to your shell config so it persists.
5. Verify SSH agent is working:

Run:

```bash
ssh-add -l
```

## 4. How this integrates with chezmoi (important)

1. Go to config file **chezmoi.yaml**.
2. Put the `sshSigningKey` value. (copy your 1Password key + {space} + it's name)
 
3. Set it in the `.gitconfig.tmpl`.
4. Run `chezmoi apply`
5. Check if the value of variable is in your `.gitconfig` file in your home directory.

Test GitHub auth:
```bash
ssh -T git@github.com
```

Expected result:
`Hi {your_name}! You've successfully authenticated, but GitHub does not provide sh`

## Takeaways

This setup was tested in MacOs and Fedora at Nov/Dec 2025. 
We know that systems can change their behaviors or features, so assume the path may differ a little in some situations. But the central idea is:

- SSH private keys live only in 1Password
- chezmoi.yaml contains data, not secrets
- SSH agent is automatic once enabled
- This setup works on macOS and Fedora
- No key files to rotate, copy, or leak

