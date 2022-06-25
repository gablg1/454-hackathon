# Sample commitment

The blockchain would serve as the point where all samples are publicly committed to. A commitment here is a piece of information that (1) cannot be used to reconstruct original (DNA) data and (2) serves at any point of time to confirm that sample data that have been produced are valid and were uploaded at a certain time and place. 

## Sample record

This is the initial notion of what constitutes the sample record
A sample submitted to the network consists of:

- Probe id
- ID of user profile connected to device when sample is taken (via App)
- ID-hash of the human part of DNA data
- Hashes of the non-human part of DNA data
- Flag: personal or shared device
- Timestamp from the blockchain on submitting the record
- Geolocation (shared optionally)
- Zion machine ID

## Storing a commitment on the ledger

Using the re-identification mechanism (such as one introduced [here](../re-identification/), a unique ID can be obtained from the personal sample (this assumes the same hypervariable loci are always part of a test array) based on the ID-hash.

The specific form of the commitment depends on properties we'd like the system to have

- one extreme is to commit almost all of the above information (hashing DNA data using a one-way function) 
- another extreme is simply combining all of the above into one hash, so that the pieces cannot be separated on chain.

The privacy/transparency balance must be thoroughly examined.

## Re-identification mechanism
Note: There needs to be a re-identification service (off-chain) due to the fact that the ID-hash is not identical. This service then assigns a unique identifier that is stable under re-identification (see [here](../re-identification/) for details).
