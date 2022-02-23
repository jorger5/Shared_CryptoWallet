# Shared CryptoWallet

This is a simple wallet that stores funds and allows users to withdraw.

## User Types

### Owner
The owner is the person that deploys the contract. This rol can withdraw all the funds from the wallet and set limits on how much users can withdraw from the wallet.

### User
Users are registered through `registerUser(address _user)` function and they have the ability to withdraw funds. Users can register freely but their allowance is initially zero (changed by the owner).
