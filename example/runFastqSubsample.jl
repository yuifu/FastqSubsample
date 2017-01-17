using FastqSubsample

ifastq = ARGS[1]
ofastq = ARGS[2]
nSubsample = parse(Int, ARGS[3])
seed = parse(Int, ARGS[4])
fastqsubsample(ifastq, ofastq, nSubsample, seed = seed)
