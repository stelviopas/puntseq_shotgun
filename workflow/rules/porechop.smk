def get_porechop_input_fastqs(wildcards):
    return config["samples"][wildcards.sample]

rule porechop:
	input: 
		get_porechop_input_fastqs
	output:
		"results/current/porechop/{sample}.porechopped.fastq.gz"
	threads: 
		config["porechop"]["threads"]
	resources:
		mem_mb=config["porechop"]["memory"]
	log: 
		"logs/porechop/{sample}.log"
	conda:
		"../envs/porechop.yaml"
	shell:
		"""
		porechop -i {input} -o {output} -t {threads} -v 2
		"""
