rule medaka_align:
  conda: "../envs/medaka.yaml"
	threads: config["medaka"]["align_threads"]
	input:
		prev_fa = "results/current/racon/{sample}.racon3/assembly.fasta",
		fq = "results/current/nanofilt/{sample}.filtered.fastq.gz"
	output:
		bam = "results/current/medaka/{sample}.medaka1/calls_to_draft.bam",
	log: "logs/medaka/{sample}.medaka1_align.txt"
	shell:
		"""
		# -m fill MD tag
		# -I split index every ~NUM input bases (default: 16G, this is larger
		# than the usual minimap2 default)
		mini_align -t {threads} -i {input.fq} -r {input.prev_fa} -m -p results/current/medaka/{wildcards.sample}.medaka1/calls_to_draft >{log} 2>&1
		"""
