# Architecture considerations

The architecture that has evolved during the hackathon has 3 system components and several participants.

## Participants

### Person providing sample

- interested in testing themselves
- incentivised to test themselves and share non-human DNA information
    - may be interested in supporting science (share non-human DNA data)
    - may be rewarded for sharing the sample

### Principal providing machine

- can be same as the person providing sample (western world)
- could be a small business owner with a side gig (developing world)

### Customers interested in aggregate statistics

- big pharma company interested in (semi) real-time tracking of strains/incidence/prevalence as related to time and space

### Customers interested in correlating DNA

- clients interested in sending a survey to people that have some DNA-identifiable trait (human DNA) or pathogen and retrieving more (e.g. behavioral) information that can then be correlated with the trait or with data from non-human sequences

Example: if there is a new strain of COVID spreading, it should be possible to send a survey to providers of the sample that asks them about symptom serverity to gain quick epidemiological insight.


## Components

### Sampling machine

Hardware distributed to customers which is able to process and sequence DNA samples. The hardware could be used by multiple users.

All computational work involving human DNA must be performed on the device. The human DNA should not leave the device.

### App

The app is (likely) mapped to one person and interacts with the sampling machine to keep track of samples from the user.

### Secure computing facility

Cloud system under control of 454 which stores non-human DNA and provides easy and fast computational access to customers.

Besides serving customers, this centralized facility is responsible for computing summaries and gaining insights into the data that can be published for PR purposes or monetized (notification of a new strain spreading that is gaining traction?).

### Blockchain

The blockchain serves as mechanism to transparently record that samples were taken and commit to the data sampled (by using a one-way function and storing the result on-chain, for example).

An additional use of the blockchain is to serve as payment rails supporting microtransactions or infrastructure for additional incentivizing tokenomics.

Note: current cost per txn on Solana seems to be $250 per 1M txns.
