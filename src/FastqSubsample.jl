__precompile__()

module FastqSubsample

using Libz

export fastqsubsample


"""
    fastqsubsample(ifastq, ofastq, nSubsample [, seed = seed])

Subsample fixed number of reads from input FASTQ file.

- ifastq: Input FASTQ. File names ending with ".gz" will be treated as gzipped files.
- ofastq: Output FASTQ. File names ending with ".gz" will be treated as gzipped files.
- nSubsample: Number of reads after subsampling. Integer.
- seed: Seed for random number generation. The results of subsampling is the same when using the same seed. Integer.


"""

function fastqsubsample(ifastq::String, ofastq::String, nSubsample::Int; kwargs...)
    S = zeros(Int, nSubsample)
    n = countFastq(ifastq)

    println("Reads in $ifastq: $n")
    println("Reads will be subsampled to: $nSubsample")
    if n < nSubsample
        println("Cannot subsample more than the number of the original reads")
        exit()
    end

    isSeeded, seed = checkSeed(kwargs, :seed, 12345)
    rng = ifelse(isSeeded, MersenneTwister(seed), MersenneTwister())


    for i in 1:nSubsample
        S[i] = i
    end

    for i in (nSubsample+1):n
        j = rand(rng, 1:i)
        if j <= nSubsample
            S[j] = i
        end
    end

    # accepted = IntSet(shuffle(rng, 1:n)[1:nSubsample])
    accepted = IntSet(S)

    writeFastqSubsample(ifastq, ofastq, accepted)
    println("Subsampled FASTQ is written: $ofastq")
end


function checkSeed(kwargs::Array{Any,1}, s::Symbol, val::Int)
    for element in kwargs
        if element[1] == s
            return true, element[2]
        end
    end
    return false, val
end

function countFastq(ifastq::String)
    n = 0

    if ismatch(r".gz$", ifastq)
        f = ZlibInflateInputStream(open(ifastq))
    else
        f = open(ifastq)
    end

    try # For avoid EOFerror of GZip.open
        for line in eachline(f)
            n += 1 
            readline(f)
            readline(f)                
            readline(f)
        end
    end

    close(f)

    n
end


function writeFastqSubsample(ifastq::String, ofastq::String, accepted::IntSet)
    i = 0
    if ismatch(r".gz$", ifastq)
        f = ZlibInflateInputStream(open(ifastq))
    else
        f = open(ifastq)
    end

    if ismatch(r".gz$", ofastq)
        fw = ZlibDeflateOutputStream(open(ofastq, "w"))
    else
        fw = open(ofastq, "w")
    end

    try
        for line in eachline(f)
            i += 1
            if in(i, accepted)
                write(fw, line)
                write(fw, readline(f))
                write(fw, readline(f))
                write(fw, readline(f))
            else
                readline(f)
                readline(f)                
                readline(f)
            end            
        end
    end

    close(f)
    close(fw)
end




end # module
