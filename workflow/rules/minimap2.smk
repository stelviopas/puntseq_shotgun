rule minimap2_sam:
    input:
        query="results/current/nanofilt/{sample}.filtered.fastq.gz",
        target="results/current/flye/{sample}/assembly.fasta",
    output:
        "results/current/minimap2/{sample}.sam",
    log:
        "logs/minimap2/{sample}.log",
    params:
        extra="-x map-pb",  # optional
        sorting="coordinate",  # optional: Enable sorting. Possible values: 'none', 'queryname' or 'coordinate'
        sort_extra="",  # optional: extra arguments for samtools/picard
    threads:
        config["minimap2"]["threads"] 
    wrapper:
        "v1.12.2/bio/minimap2/aligner"

