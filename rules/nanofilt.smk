def get_nanofilt_input_fastqs(wildcards):
    return config["nanofilt_input"][wilcards.nanofilt_sample]

def get_amplicon_input_fastqs(wildcards):
    return config["amplicon"][wildcards.amplicon]

rule nanofilt:
        input: "results/current/porechop/{sample}.porechopped.fastq.gz"
        output: "results/current/nanofilt/{sample}.filtered.fastq.gz"
        resources:
                mem_mb=config["nanofilt"]["memory"]
        log:
                "logs/nanofilt/{sample}.log"
        conda:
                "../envs/nanofilt.yaml"
        params:
                q=config["nanofilt"]["q"],
                l=config["nanofilt"]["l"]
        threads:
                config["nanofilt"]["threads"]

        shell:
                "gunzip -c {input} | NanoFilt -q {params.q} -l {params.l} | gzip > {output}"

rule manual_nanofilt:
        input: "results/current/samtools/leptospira_interrogans_shotgun_new_{mapq}.fastq"
        output: "results/current/manual_nanofilt/leptospira_interrogans_shotgun_new_{mapq}.filtered.fastq.gz"
        resources:
                mem_mb=config["nanofilt"]["memory"]
        log:
                "logs/manual_nanofilt/leptospira_interrogans_shotgun_new_{mapq}.log"
        conda:
                "../envs/nanofilt.yaml"
        params:
                q=config["nanofilt"]["q"],
                l=config["nanofilt"]["l"]
        threads:
                config["nanofilt"]["threads"]

        shell:
                "NanoFilt {input} -q {params.q} -l {params.l} | gzip > {output}"

rule nanofilt_amplicon:
        input: "results/current/porechop/{amplicon}.porechopped.fastq.gz"
        output: "results/current/amplicon/{amplicon}.filtered.fastq"
        resources:
                mem_mb=config["nanofilt"]["memory"]
        log:
                "logs/amplicon/{amplicon}.log"
        conda:  
                "../envs/nanofilt.yaml"
        params: 
                min_length=config["nanofilt"]["min_length"],
                max_length=config["nanofilt"]["max_length"]
        threads:
                config["nanofilt"]["threads"]

        shell:  
                "gunzip -c {input} | NanoFilt -l {params.min_length} --maxlength {params.max_length} > {output}"

rule convert_fasta:
        input: "results/current/amplicon/{amplicon}.filtered.fastq",
	output: "results/current/amplicon/{amplicon}.filtered.fasta",
        log: "logs/amplicon/{amplicon}.log"
        conda:  
                "../envs/fastx_toolkit.yaml"
        shell:  
                "fastq_to_fasta -i {input} -o {output}"

# [TODO] get rid of hardcoded pathes 

rule merge_fasta: 
        input: "results/current/amplicon/BC04_porechop_fahad.filtered.fasta",
               "results/current/amplicon/BC02_porechop_fahad.filtered.fasta",
               "results/current/amplicon/BC03_porechop_fahad.filtered.fasta",
               "results/current/amplicon/BC04_new.filtered.fasta",
               "results/current/amplicon/BC02_new.filtered.fasta",
               "results/current/amplicon/BC03_new.filtered.fasta"
        output:
                fahad = "results/current/amplicon/amplicon_new.fasta",
                new = "results/current/amplicon/amplicon_fahad.fasta"
        shell:         
                """
                cat results/current/amplicon/*_porechop_fahad.filtered.fasta  > {output.fahad}
                cat results/current/amplicon/*_new.filtered.fasta  > {output.new}

                """

