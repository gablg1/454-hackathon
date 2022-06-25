# Prototype assumptions

- We can retrieve 100 base pairs from a given location(s)
- It's possible to do this from 3-5 locations
- We assume the reader has a 1/100 failure rate and the data is corrupted randomly and independently
- We assume that people differ in at least 20% of the genetic material
- We assume that the user supplies an actual sample
- We want to be able to generate an ephemeral set of information that re-identifies the user to one application.

## Multiple hashed sequences from cribs with salt

See notebook in `src/` directory for simulations reflecting the above assumptions.
