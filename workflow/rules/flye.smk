rule flye:
        input: "results/current/nanofilt/{sample}.filtered.fastq.gz"
	output: "results/current/flye/{sample}/assembly.fasta"
        threads:
                config["flye"]["threads"]
        resources:
                mem_mb=config["flye"]["memory"]
        log:
                "logs/flye/{sample}.log"
        conda:
                "../envs/flye.yaml"
        shell:
                "flye --meta --nano-raw {input} -o results/current/flye/{wildcards.sample} -i 1 --threads {threads}"

