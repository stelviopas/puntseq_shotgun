rule metabat2:
  conda: "../envs/metabat2.yaml"
	threads: config["metabat2"]["threads"]
	input:
		fa = "results/current/bioawk/{sample}.medaka1_filtered/assembly.fasta"
	output:
		"results/current/metabat2/{sample}/{sample}" #clusters
	log: "logs/metabat2/{sample}.txt"
	shell:
		"""
		# --saveCls Save cluster memberships as a matrix format
		# --minClsSize Minimum size of a bin as the output
		# --unbinned Generate [outFile].unbinned.fa file for unbinned contigs
		metabat2 -i {input.fa} -o {output} -t {threads} -v --saveCls --minClsSize 50000 --unbinned  >{log} 2>&1
		"""
