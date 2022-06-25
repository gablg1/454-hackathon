# Bank authentication protocol

The protocol involves three actors: a user, a device and the bank.

The scenario runs as follows: the user walks into the bank premises and provides their DNA to secure a loan. She is being watched over by a bank clerk while providing the sample. The bank than receives a derived set of information that allows the bank to identify how much this person has loaned out (and if they hit their loan ceiling).

## Requirements

### User

- The user wishes for a low friction method to secure a loan.
- The user does not wish to reveal their DNA information to the bank.
- The user wants to prevent the bank from using this ID anywhere else.

### Bank

- The bank wishes to store an identifier for the user.
- The bank wishes to be able to re-identify a user.
- The bank wishes to prevent replay attacks (same DNA used twice).
- The bank wishes to be able to collect on the load (not in scope).

