# BTC-Verify

Automated reproducible build verification for Bitcoin wallets.

## The Problem

Bitcoin users need to trust that wallet software binaries match their source code. Manual verification is time-consuming and error-prone.

## The Solution

BTC-Verify automates the three-day verification process I developed while verifying Sparrow Wallet v2.3.1.

## Current Status

🚧 **In Development** - Building GPG verification automation

## Quick Start

### Verify GPG Signatures
```powershell

# Clone this repo
git clone https://github.com/Thegreenpiranha/btc-verify.git
cd btc-verify

# Run verification on Sparrow Wallet
powershell -ExecutionPolicy Bypass -File src\verify-gpg.ps1 -RepoUrl "https://github.com/sparrowwallet/sparrow.git" -Tag "2.3.1"
```

### Example Output

Script will verify GPG signatures and report PASS/FAIL status.

## Planned Features

- [ ] Automated GPG signature verification
- [ ] Reproducible build comparison
- [ ] Binary hash verification
- [ ] Multi-wallet support (Sparrow, Electrum, Wasabi)

## Tech Stack

- Python 3.x
- PowerShell/Bash scripting
- Git/GPG tools

## About

Built by Sean from Bitesize Media - Bitcoin privacy research and verification.

## License

MIT