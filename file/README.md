# HR Onboarding Smart Contract System

A secure blockchain-based system for managing employee onboarding and benefits using Clarity smart contracts.

## Overview

This project implements a complete HR management system using two main contracts:

1. **Onboarding Contract**: Handles the core employee registration, approval, and management process
2. **Benefits Contract**: Manages employee benefits enrollment and administration

## Features

### Onboarding Contract
- Secure employee registration with role-based access control
- Admin management system
- Employee status tracking (Pending, Active, Terminated)
- Document hash storage for verification
- Role-based permissions

### Benefits Contract
- Integration with onboarding contract for employee verification
- Benefits plan management (health, retirement, PTO)
- Eligibility tracking
- Benefits status lifecycle management

## Security Features

- Role-based access control
- Contract owner privileges
- Admin management system
- Principal-based authentication
- Status validation before critical operations
- Cross-contract verification

## Getting Started

### Prerequisites
- [Clarinet](https://github.com/hirosystems/clarinet) installed
- [Stacks blockchain](https://www.stacks.co/) development environment

### Installation

1. Clone this repository
2. Navigate to the project directory
3. Run `clarinet check` to verify contracts
4. Run `clarinet console` to interact with contracts

## Usage Examples

### Registering a New Employee

```clarity
(contract-call? .onboarding register-employee 
  'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM 
  "John Doe" 
  "Software Engineer" 
  "2025-04-29" 
  "0x123456789abcdef")
```

### Approving an Employee

```clarity
(contract-call? .onboarding approve-employee 
  'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
```

### Enrolling Employee in Benefits

```clarity
(contract-call? .benefits enroll-employee 
  .onboarding
  'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM
  "Premium Health Plan"
  "401K+"
  20)
```

## Project Structure

```
hr-onboarding/
├── Clarinet.toml       # Project configuration
├── README.md           # Project documentation
└── contracts/
    ├── onboarding.clar # Employee onboarding contract
    └── benefits.clar   # Employee benefits contract
```

## License

This project is licensed under the MIT License.
