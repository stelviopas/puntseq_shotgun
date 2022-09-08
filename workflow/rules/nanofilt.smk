def get_nanofilt_input_fastqs(wildcards):
    return config["samples"][wildcards.sample]

rule nanofilt:
        input: "results/current/porechop/{sample}.porechopped.fastq.gz"
        output: "results/current/nanofilt/{sample}.filtered.fastq.gz"
        resources:
                mem_mb=config["nanofilt"]["memory"]
        log:
                "logs/nanofilt/{sample}.log"
        conda:
                "../envs/nanofilt.yaml"
        shell:
                "gunzip -c {input} | NanoFilt -q 7 -l 200 | gzip > {output}"

