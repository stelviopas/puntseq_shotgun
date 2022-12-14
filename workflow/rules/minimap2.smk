rule minimap2_bam:
    input:
        query="results/current/nanofilt/{sample}.filtered.fastq.gz",
        target="results/current/medaka/{sample}.medaka3/assembly.fasta",
    output:
        "results/current/vamb/{sample}.bam",
    log:
        "logs/minimap2/{sample}.log",
    params:
        extra="-ax map-ont",
        sorting="coordinate",  # optional: Enable sorting. Possible values: 'none', 'queryname' or 'coordinate'
    threads:
        config["minimap2"]["threads"] 
    wrapper:
        "v1.12.2/bio/minimap2/aligner"

rule vamb:
    conda: "envs/vamb.yaml"
    input: fasta=
