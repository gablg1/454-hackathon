# Identity computation

[Civic](https://www.civic.com/)
[]

# DNA randomness

[Schmitt & Herzel - Shannon entropy](https://www.researchgate.net/publication/13883592_Estimating_the_Entropy_of_DNA_Sequences)

- apparently the entropy of sequences is high in yeast genome (almost maximal).


# DNA fingerprinting/identification

[WebMD blog](https://www.webmd.com/a-to-z-guides/dna-fingerprinting-overview)
- Human DNA is 99.9% the same
- uses word identification in the wrong way (actually solves matching problem)


[Saad, 2005](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1200713/)
- Human DNA is 99% the same
- initial methods from 1985 involve VNTR (variable numbers of tandem repeats) and STR (short tandem repeat) markers
- pick tiny bits of information from various places in the genome
- CODIS is a US system for storing DNA of convicted felons
- based on the amplification of 13 core STR loci
- uses electrophoresis to compute the number of repetitions and identify differences between individuals
- 13 sites are enough to make an identification in a database (how so?)

[Announcement on DNA ident](https://news.columbia.edu/news/new-software-can-verify-someones-identity-their-dna-minutes) [Zaaijer et al 2017](https://elifesciences.org/articles/27798)

- MinION device developed to study bacteria
- Now applied to **re-identification** of humans by sequencing random strings
- select individual variants in DNA
- using a bayesian algorithm, compare this mix with other profiles on file (matching)
- tests show the method can validate an individual’s identity after cross-checking between **60 and 300** variants

# General fingerprinting

[LSH](https://en.wikipedia.org/wiki/Locality-sensitive_hashing)