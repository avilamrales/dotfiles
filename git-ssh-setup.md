# Linux SSH Setup for Git

## 1. Generate a New SSH Key
Run the following command, replacing the email with your Git provider email:
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```
* Press **Enter** to accept the default file location.
* Enter a secure passphrase (optional).

## 2. Add Key to SSH Agent
Start the agent and add your private key:
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

## 3. Add Public Key to Git Provider
Display and copy your public key:
```bash
cat ~/.ssh/id_ed25519.pub
```
1. Copy the entire output.
2. Go to **Settings > SSH and GPG keys** in your provider.
3. Click **New SSH Key**, name it, and paste the key.

## 4. Test Connection
Verify the setup (example for GitHub):
```bash
ssh -T git@github.com
```

## 5. Clone Repository
Clone using the SSH URL:
```bash
git clone git@github.com:username/repository-name.git
```

## 6. Force SSH via Git Config (Optional)
Automatically rewrite HTTPS URLs to use SSH:
```bash
git config --global url."git@github.com:".insteadOf "https://github.com/"
```

---

## Cryptographic Recommendations
**Ed25519** is the strict industry standard for generating personal key pairs due to its high security and compact size. 

Additionally, GitHub now uses **post-quantum cryptography** (`sntrup761x25519-sha512`) at the transport layer to secure data in transit against future quantum computer attacks (automatically negotiated on OpenSSH 9.0+).

**Official Documentation:**
* [Generating a new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
* [Post-Quantum Security for SSH Access](https://github.blog/engineering/platform-security/post-quantum-security-for-ssh-access-on-github/)
