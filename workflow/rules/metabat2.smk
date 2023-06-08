rule metabat2:
  conda: "/home/haicu/anastasiia.grekova/workspace/puntseqWGS/.snakemake/conda/927c756d"
	threads: config["metabat2"]["threads"]
	input:
		fa = "results/current/bioawk/{sample}/assembly.fasta"
	output:
		"results/current/metabat2/{sample}/{sample}" # clusters summary
		#dynamic("results/current/metabat2/{sample}/{sample}.{metabat_n}.fa") # do not know how many bins are there yet
	log: "logs/metabat2/{sample}.txt"
	params: minClsSize = config["metabat2"]["minClsSize"]
	shell:
		"""
		# --saveCls Save cluster memberships as a matrix format
		# --minClsSize Minimum size of a bin as the output
		# --unbinned Generate [outFile].unbinned.fa file for unbinned contigs
		metabat2 -i {input.fa} -o {output} -t {threads} -v --saveCls --minClsSize {params.minClsSize} --unbinned  >{log} 2>&1
		"""
