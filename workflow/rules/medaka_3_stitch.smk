rule medaka_stitch:
  conda: "../envs/medaka.yaml"
	threads: config["medaka"]["stitch_threads"]
	input:
		hdf = "results/current/medaka/{sample}.medaka1/contigs.hdf",
		draft = "results/current/racon/{sample}.racon3/assembly.fasta"
	output:
		fa = "results/current/medaka/{sample}.medaka1/assembly.fasta",
	log: "logs/medaka/{sample}.medaka1_stitch.txt"
	shell:
		"""
		medaka stitch --threads {threads} {input.hdf} {input.draft} {output.fa} >{log} 2>&1
		"""
