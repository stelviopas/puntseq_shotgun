rule das_tool:
  conda: "../envs/das_tool.yaml"
	threads: config["das_tools"]["threads"]
	input:
		metabat = "results/current/betabat2/{sample}/",
		maxbin = "results/current/maxbin2/{sample}/{sample}.summary",
		vamb = ""
	output:
		dir = "results/current/das_tool/{sample}/"	
	log: "logs/das_tool/{sample}.txt"
	shell:
		"""
		DAS_TOOL -i {input.metabat}, \
		{input.maxbin}, \
		{input.vamb} -o \
		-l metabat, maxbin, vamb \
		-c merged_contigs.fasta \
		-o {output.dir} --t {threads} >{log} 2>&1
		"""
