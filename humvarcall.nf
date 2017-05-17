#!/usr/bin/env nextflow

params.in = "/home/abraham/human_variant/input_files/SP1.fq"
params.ref = "/home/abraham/human_variant/reference_files/hg38.fa"
params.index = "/home/abraham/human_variant/reference_files/hg38.fa"

sequences = file(params.in)
refgenome = file(params.ref)
indexref = file(params.index)

process AdaptorTrim {

    input:
    file 'input.fa' from sequences

    output:
    file 'seq_*' into records

    """
    fastx_clipper -l 20 -v -i input.fa -o seq_*
    """

}

process QualityTrim {

    input:
    file x from records
    
    output:
    file 'qualtrimmed' into recordsqual

    """
    fastq_quality_filter -i $x -o qualtrimmed    
    """
}

process map_to_reference {
    input:
    file y from recordsqual
    file indexed from indexref
    file ref from refgenome

    output:
    file 'mapped' into recordsmap

    """
    bwa mem indexed y 
    """
}


result.subscribe { println it }
