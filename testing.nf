#!/usr/bin/env nextflow

params.in3 = "/home/abraham/human_variant/input_files/SP1.fq"
params.in1 = "/home/abraham/human_variant/input_files/UCSC_chr1_WithSyntheticVariants_And_ERR250949_Variants_Exome_50X_NEAT_read1.fq"
params.in2 = "/home/abraham/human_variant/input_files/UCSC_chr1_WithSyntheticVariants_And_ERR250949_Variants_Exome_50X_NEAT_read2.fq"


sequences1 = file(params.in1)
sequences2 = file(params.in2)

process AdaptorTrim {

    input:
    file 'input1.fq' from sequences1
  
    output:
    file 'seq_1*' into records1
  
    """
    fastx_clipper -l 20 -v -i input1.fq -o seq_1*
    """

}

process QualityTrim {

    input:
    file x1 from records1
    
    output:
    file 'qualtrimmed1' into recordsqual1

    """
    fastq_quality_filter -i $x1 -o qualtrimmed1
    """
}

