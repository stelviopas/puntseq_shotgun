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
        params:
                model_flag=config["flye"]["model_flag"]
        shell:
                "flye --meta {params.model_flag} {input} -o results/current/flye/{wildcards.sample} -i 1 --threads {threads}"

rule reference_based_flye:
        input: "results/current/nanofilt/leptospira_interrogans_shotgun_new.filtered.fastq.gz"
        #input: "results/current/samtools/leptospira_interrogans_shotgun_new.fastq" # take unfiltered reads for now(nanfilt bug), note there are some with q<9 and len<200
        output: "results/current/flye/leptospira_interrogans_shotgun_new/assembly.fasta"
        threads:
                config["flye"]["threads"]
        resources:
                mem_mb=config["flye"]["memory"]
        log:
                "logs/flye/leptospira_interrogans_shotgun_new.log"
        conda:
                "../envs/flye.yaml"
        params:
                model_flag=config["flye"]["model_flag"],
                polish_rounds=config["flye"]["polish_rounds"]
        shell:
                "flye {params.model_flag} {input} -o results/current/flye/leptospira_interrogans_shotgun_new -i {params.polish_rounds} --threads {threads}"

