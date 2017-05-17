#!/usr/bin/env nextflow

params.in1 = "/home/abraham/human_variant/input_files/UCSC_chr1_WithSyntheticVariants_And_ERR250949_Variants_Exome_50X_NEAT_read1.fq"
params.in2 = "/home/abraham/human_variant/input_files/UCSC_chr1_WithSyntheticVariants_And_ERR250949_Variants_Exome_50X_NEAT_read2.fq"
params.ref = "/home/abraham/human_variant/reference_files/hg38.fa"

sequences1 = file(params.in1)
sequences2 = file(params.in2)
refgenome = file(params.ref)

process AdaptorTrim {

    input:
    file 'input1.fa' from sequences1
    file 'imput2.fa' from sequences2

    output:
    file 'seq_*1' into records1
    file 'seq_*2' into records2

    """
    fastx_clipper -l 20 -v -i input1.fa -o seq_*1
    fastx_clipper -l 20 -v -i input2.fa -o seq_*2
    """

}

process QualityTrim {

    input:
    file x1 from records1
    file x2 from records2
    
    output:
    file 'qualtrimmed1' into recordsqual1
    file 'qualtrimeed2' into recordsqual2

    """
    fastq_quality_filter -i $x1 -o qualtrimmed1
    fastq_quality_filter -i $x2 -o qualtrimmed2
    """
}

process map_to_reference {
    input:
    file y1 from recordsqual1
    file y2 from recordsqual2
    file ref from refgenome

    output:
    file 'mapped' into recordsmap

    """
    bwa mem $ref $y1 $y2 
    """
}


result.subscribe { println it }
