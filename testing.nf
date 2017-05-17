#!/usr/bin/env nextflow

params.in1 = "/home/abraham/human_variant/input_files/UCSC_chr1_WithSyntheticVariants_And_ERR250949_Variants_Exome_50X_NEAT_read1.fq"
params.in2 = "/home/abraham/human_variant/input_files/UCSC_chr1_WithSyntheticVariants_And_ERR250949_Variants_Exome_50X_NEAT_read2.fq"

sequences1 = file(params.in1)
sequences2 = file(params.in2)

process AdaptorTrim {

    input:
    file 'input1.fq' from sequences1
    file 'input2.fq' from sequences2

    output:
    file 'seq_1*' into records1
    file 'seq_2*' into records2

    """
    fastx_clipper -l 20 -v -i input1.fq -o seq_1*
    fastx_clipper -l 20 -v -i input2.fq -o seq_2*
    """

}

process QualityTrim {

    input:
    file x1 from records1
    file x2 from records2
    
    output:
    file 'qualtrimmed1' into recordsqual1
    file 'qualtrimmed2' into recordsqual2

    """
    fastq_quality_filter -i $x1 -o qualtrimmed1
    fastq_quality_filter -i $x2 -o qualtrimmed2
    """
}

result.subscribe { println it }
