# FastqSubsample
Subsample sequenced reads in FASTQ formt using Julia

## Features
* Faster than `seqtk` when subsampling 100M reads from a FASTQ file with 481M reads
* Smaller 'maximum memory usage' than `seqtk` when subsampling 100M reads from a FASTQ file with 481M reads


## Methods
Reservoir sampling (https://en.wikipedia.org/wiki/Reservoir_sampling) + Loading FASTQ twice


## Usage
```
using FastqSubsample.jl
FastqSubsample(ifastq, ofastq, nSubsample, seed = seed)
```

- `ifastq`: File path of an input FASTQ file. Interpret as gzipped file if it ends with `.gz`.
- `ofastq`: File path of a subsampled FASTQ file. Interpret as gzipped file if it ends with `.gz`.
- `nSubsample`: The number of reads after subsampling.
- `seed`: Seed.

For paired end reads:

```
using FastqSubsample.jl
seed = 123456
FastqSubsample("in.R1.fastq.gz", "out.R1.fastq.gz", nSubsample, seed = seed)
FastqSubsample("in.R2.fastq.gz", "out.R2.fastq.gz", nSubsample, seed = seed)
```

## TODO
- [ ] Make docker image
