using FastqSubsample
using Base.Test

ifastq = joinpath(dirname(@__FILE__), "input.fastq.gz")
ofastq = joinpath(dirname(@__FILE__), "output.fastq.gz")
ofastq2 = joinpath(dirname(@__FILE__), "output2.fastq.gz")
nSubsample = 40

fastqsubsample(ifastq, ofastq, nSubsample, seed = 1234)
fastqsubsample(ifastq, ofastq2, nSubsample, seed = 1234)

# Test for number of subsampled reads
@test FastqSubsample.countFastq(ofastq) == nSubsample
@test FastqSubsample.countFastq(ofastq2) == nSubsample

# Test for reproducibility
mdfive1 = split(chomp(readstring(`md5sum-lite $ofastq`)), r"\s+")[1]
mdfive2 = split(chomp(readstring(`md5sum-lite $ofastq2`)), r"\s+")[1]
@test mdfive1 == mdfive2

