IDS, = glob_wildcards(config["guppy"]["pass_path"] + "{id}.fastq.gz")
rule guppy_barcoder:
	input: 
		expand(config["guppy"]["pass_path"] + "{id}.fastq.gz", id=IDS)
	output:
		config["samples"]["shotgun_new"],
		config["samples"]["BC02_new"],
		config["samples"]["BC03_new"],
		config["samples"]["BC04_new"]
	threads: 
		config["guppy"]["num_callers"]
	resources:
		mem_mb=config["guppy"]["memory"]
	log: 
		"logs/guppy/demultiplexed/guppy.log"
	params:
		save_path="results/current/guppy/demult/",
		input_path=config["guppy"]["pass_path"],
		barcode_kits=config["guppy"]["barcode_kits"]
	shell:
		"""
		guppy_barcoder --input_path {params.input_path} --save_path {params.save_path} --barcode_kits {params.barcode_kits} -x 'cuda:0' --compress_fastq
		cat {params.save_path}barcode02/*.fastq.gz > {params.save_path}BC02.fastq.gz		
		cat {params.save_path}barcode03/*.fastq.gz > {params.save_path}BC03.fastq.gz
		cat {params.save_path}barcode04/*.fastq.gz > {params.save_path}BC04.fastq.gz
		cat {params.save_path}unclassified/*.fastq.gz > {params.save_path}shotgun.fastq.gz"""
