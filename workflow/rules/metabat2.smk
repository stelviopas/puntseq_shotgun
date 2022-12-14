rule metabat2:
  conda: "../envs/metabat2.yaml"
	threads: config["metabat2"]["threads"]
	input:
		fa = "results/current/bioawk/{sample}.medaka1_filtered/assembly.fasta"
	output:
		dir = "results/current/metabat2/{sample}/"	
	log: "logs/metabat2/{sample}.txt"
	shell:
		"""
		# --saveCls Save cluster memberships as a matrix format
		metabat2 -i {input.fa} -o {output.dir}bin -t {threads} -v --saveCls  >{log} 2>&1
		"""
