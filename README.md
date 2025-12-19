# Tele

Telemedicine platform with encrypted consultations and private health data

## Overview

This project implements a privacy-preserving solution using Zama's Fully Homomorphic Encryption Virtual Machine (FHEVM). It enables computation on encrypted data without requiring decryption, ensuring data confidentiality throughout the processing pipeline.

## Problem Statement

Traditional encryption schemes require data to be decrypted before computation can occur. This creates a security vulnerability where sensitive information is exposed during processing. Our solution addresses this by leveraging homomorphic encryption to perform operations directly on encrypted data.

## Solution Architecture

The system utilizes Zama FHEVM to maintain data encryption throughout the computation lifecycle. Smart contracts process encrypted inputs and produce encrypted outputs, with decryption only occurring when explicitly authorized by the data owner.

## Technology Stack

- **Zama FHEVM v0.9** - Fully homomorphic encryption on Ethereum
- **Hardhat** - Development framework
- **Solidity 0.8.24** - Smart contract language
- **TypeScript** - Type-safe development environment

## Installation

`ash
npm install
`

## Compilation

`ash
npm run compile
`

## Deployment

Configure your .env file with the required parameters (see env.template).

Deploy to Sepolia testnet:

`ash
npm run deploy:sepolia
`

## Smart Contracts

- `PrescriptionSystem`
- `TelemedicineCore`

Contract addresses are stored in contracts.json after deployment.

## Technical Details

The implementation follows Zama's self-relaying decryption model, where decryption is performed off-chain using the Relayer SDK. Contracts use FHE.makePubliclyDecryptable() to authorize decryption and FHE.verifySignatures() to verify decrypted values.

## Testing

`ash
npm test
`

## License

MIT License


