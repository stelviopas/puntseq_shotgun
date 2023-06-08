rule maxbin2:
  conda: "/home/haicu/anastasiia.grekova/miniconda3/envs/maxbin2"
	threads: config["maxbin2"]["threads"]
	input:
		fq = "resources/{sample}.fastq",
		fa = "results/current/bioawk/{sample}/assembly.fasta"
	output:
		#summary = "results/current/maxbin2/{sample}/{sample}.summary",
		bins = dynamic("results/current/maxbin2/{sample}.{maxbin_n}.fasta")
	#log: "logs/maxbin2/{sample}_{maxbin_n}.txt"
	shell:
		"""
		run_MaxBin.pl -contig {input.fa} -reads {input.fq} -out results/current/maxbin2/{wildcards.sample} -thread {threads} -plotmarker
		"""
