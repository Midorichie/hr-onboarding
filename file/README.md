# HR Onboarding and Employee Verification

This repository contains a Clarity-based smart contract system for decentralized HR onboarding and employee verification on the Stacks blockchain.

## Prerequisites
- Node.js >= 14
- Clarinet CLI (`npm install -g @hirosystems/clarinet`)

## Setup
1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/hr-onboarding.git
   cd hr-onboarding
   ```
2. Install Clarinet (if not installed):
   ```bash
   npm install -g @hirosystems/clarinet
   ```

## Project Structure
- `contracts/` — Clarity smart contracts.
- `tests/` — Clarinet integration tests.
- `Clarinet.toml` — Project/network configuration.

## Usage
- Start a local chain:
  ```bash
  clarinet develop
  ```
- Run tests:
  ```bash
  clarinet test
  
