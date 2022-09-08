def get_fastqc_input_fastqs(wildcards):
    return config["samples"][wildcards.sample]

rule initial_fastqc:
    input:
        get_fastqc_input_fastqs
    output:
        html="results/current/fastqc/{sample}.html",
        zip="results/current/fastqc/{sample}_fastqc.zip" # the suffix _fastqc.zip is necessary for multiqc to find the file. If not using multiqc, you are free to choose an arbitrary filename
    params: 
	"--quiet"
    log:
        "logs/fastqc/{sample}.log"
    threads: config["fastqc"]["threads"] 
    wrapper:
        "v1.10.0/bio/fastqc"
# [TODO] refactor fastQC to take different arguments according to input files like done in nanoplot
# or remove, since fastQC is not very useful for Nanopore data 
"""
rule after_porechop_fastqc:
    input:
        "results/current/porechop/{sample}.porechopped.fastq.gz"
    output:
        html="results/current/fastqc/{sample}.porechopped.html",
        zip="results/current/fastqc/{sample}.porechopped_fastqc.zip"
    params:
        "--quiet"
    log:
        "logs/fastqc/{sample}.porechopped.log"
    threads: config["fastqc"]["threads"]
    wrapper:
        "v1.10.0/bio/fastqc"
"""
