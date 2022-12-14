rule maxbin2:
  conda: "../envs/maxbin2.yaml"
	threads: config["maxbin2"]["threads"]
	input:
		fa = "results/current/bioawk/{sample}.medaka1_filtered/assembly.fasta",
		fq = "results/current/nanofilt/{sample}.filtered.fastq.gz"
	output:
		summary = "results/current/maxbin2/{sample}/{sample}.summary"
	log: "logs/maxbin2/{sample}.txt"
	shell:
		"""
		run_MaxBin.pl -contig {input.fa} -reads {input.fq} -out results/current/maxbin2/{wildcards.sample}/{wildcards.sample} -thread {threads}
		"""
