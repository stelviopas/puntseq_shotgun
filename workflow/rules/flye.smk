rule flye:
        input: "results/current/downsampled/{sample}.filtered.fastq.gz"
	output: "results/current/flye/{sample}/assembly.fasta"
        threads:
                config["flye"]["threads"]
        resources:
                mem_mb=config["flye"]["memory"]
        log:
                "logs/flye/{sample}.log"
        conda:
                "../envs/flye.yaml"
        params:
                model_flag=config["flye"]["model_flag"]
        shell:
                "flye --meta {params.model_flag} {input} -o results/current/flye/{wildcards.sample} -i 1 --threads {threads}"

rule reference_based_flye:
        input: "results/current/manual_nanofilt/leptospira_interrogans_shotgun_new_{mapq}.filtered.fastq.gz"
        #input: "results/current/samtools/leptospira_interrogans_shotgun_new.fastq" # NB: unfiltered reads for now(nanofilt bug) include some with with q<9 and len<200
        output: "results/current/reference_based_flye/leptospira_interrogans_shotgun_new_{mapq}/assembly.fasta"
        threads:
                config["flye"]["threads"]
        resources:
                mem_mb=config["flye"]["memory"]
        log:
                "logs/reference_based_flye/leptospira_interrogans_shotgun_new_{mapq}.log"
        conda:
                "../envs/flye.yaml"
        params:
                model_flag=config["flye"]["model_flag"],
                polish_rounds=config["flye"]["polish_rounds"]
        shell:
                "flye {params.model_flag} {input} -o results/current/reference_based_flye/leptospira_interrogans_shotgun_new_{wildcards.mapq} -i {params.polish_rounds} --threads {threads}"

