# BTC-Verify

Automated reproducible build verification for Bitcoin wallets.

## The Problem

Bitcoin users need to trust that wallet software binaries match their source code. Manual verification is time-consuming and error-prone. Most users skip this critical security step.

## The Solution

BTC-Verify automates the three-day verification process I developed while verifying Sparrow Wallet v2.3.1:
- **Day 1:** Repository analysis (GPG signatures, commit history, community metrics)
- **Day 2:** Reproducible build verification (compile from source, compare binaries)
- **Day 3:** Feature testing (testnet validation, privacy feature checks)

## Current Status

**Phase 1 Complete:** GPP signature verification working and tested
**Phase 2 Complete:** Build automation and binary comparison framework

## Quick Start

**Requirements:** Git Bash (Windows), or any bash terminal (Linux/Mac)

### Verify Bitcoin Core
```bash
# Clone this repo
git clone https://github.com/Thegreenpiranha/btc-verify.git
cd btc-verify

# Verify Bitcoin Core v27.0
./src/verify-gpg.sh https://github.com/bitcoin/bitcoin.git v27.0
```

**Output:**
```
✓ SUCCESS: Valid GPG signature found
gpg: Good signature from "Michael Ford (bitcoin-otc) <fanquake@gmail.com>"
Status: PASS
```

### Verify Other Wallets
```bash
# General usage
./src/verify-gpg.sh <repo-url> <tag-version> [optional-gpg-key-id]

# Examples
./src/verify-gpg.sh https://github.com/sparrowwallet/sparrow.git 1.9.1
./src/verify-gpg.sh https://github.com/spesmilo/electrum.git 4.5.5
```

## Roadmap

- [x] **Phase 1:** GPG signature verification 
- [x] **Phase 2:** Build automation framework
- [ ] **Phase 3:** Binary comparison and reporting
- [ ] **Phase 4:** Multi-wallet support

## Tech Stack

- Bash scripting
- Git/GPG tools
- Bitcoin Core (for future testnet validation)

## About

Built by Sean from Bitesize Media - Bitcoin privacy research and verification.

## License

MIT
