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

**Phase 1 Complete:** GPG signature verification working and tested  
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
SUCCESS: Valid GPG signature found
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

### Build Verification (Advanced)
```bash
# Automated build and comparison
./src/build-verify.sh configs/sparrow.conf 2.0.0
```

## Real-World Build Challenges

During development, this tool revealed common reproducible build issues:

1. **Java Version Compatibility**: Sparrow 1.9.1 requires Java 21, but fails with Java 22 (class file version 66 error)
2. **Git Submodules**: Projects like Sparrow require `--recurse-submodules` flag to include dependencies like `drongo`
3. **Dependency Availability**: Maven repositories can become unavailable or have certificate issues over time
4. **Build Environment Complexity**: Reproducible builds require exact matching of compiler versions, dependencies, and build tools

These are the exact challenges that make automated verification valuable - and why most users skip verification entirely.

### Successful Verifications

- **Bitcoin Core v27.0**: GPG signature verified successfully
- **Binary Comparison Logic**: Tested with sample files, SHA256 hash matching works correctly
- **Build Automation Framework**: Successfully handles git operations, submodules, and build orchestration

## Features

### Phase 1: GPG Verification
- Automated GPG signature checking
- Support for custom GPG key IDs
- Clear PASS/FAIL reporting
- Tested on Bitcoin Core v27.0

### Phase 2: Build Automation
- Configuration-based build system
- Git submodule support
- Binary comparison with SHA256 hashing
- Size and hash verification
- Build environment detection

## Roadmap

- [x] **Phase 1:** GPG signature verification - COMPLETE
- [x] **Phase 2:** Build automation framework - COMPLETE
- [ ] **Phase 3:** Resolve dependency issues and complete full build verifications
- [ ] **Phase 4:** Multi-wallet configuration library
- [ ] **Phase 5:** Automated testing suite and CI/CD integration

## Tech Stack

- Bash scripting
- Git/GPG tools
- SHA256 cryptographic hashing
- Gradle/Maven build system integration
- Bitcoin Core (for future testnet validation)

## Repository Structure
```
btc-verify/
├── src/
│   ├── verify-gpg.sh          # GPG signature verification
│   ├── build-verify.sh        # Build automation
│   └── compare-builds.sh      # Binary comparison logic
├── configs/
│   └── sparrow.conf           # Wallet build configurations
└── README.md
```

## Contributing

This tool was built to solve a real problem in Bitcoin security verification. Contributions welcome, especially:
- Additional wallet configurations
- Build environment compatibility improvements
- Dependency resolution strategies
- Documentation improvements

## About

Built by Sean from Bitesize Media - Bitcoin privacy research and verification.

**Why This Matters**: Reproducible builds are the gold standard for verifying that distributed binaries contain no hidden modifications. This tool makes that verification accessible to more users and documents the real challenges involved.

## License

MIT

