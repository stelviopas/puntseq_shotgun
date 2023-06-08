rule coverm:
	conda: "coverm"
	threads: config["coverm"]["threads"]
	input:
		reads = "resources/{sample}.fastq",
		bins = dynamic(expand("results/current/das_tool/{{sample}}/{{sample}}_DASTool_bins/{{binner}}.contigs.fa"))
	output:
		"results/current/coverm/{sample}_summary.txt"
	#log: "logs/coverm/{sample}.txt"
	shell:
		"""
		coverm genome --single {input.reads} \
			-m relative_abundance -p minimap2-ont \
			--genome-fasta-files {input.bins} --genome-fasta-extension fa \
			--output-file {output} -t {threads} > {log} 
		"""
