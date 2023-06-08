IDS, = glob_wildcards(config["guppy"]["input_path"] + "{id}.fast5")
rule guppy:
	input: 
		expand(config["guppy"]["input_path"] + "{id}.fast5", id=IDS)
	output:
		"results/current/guppy/basecalled/pass/",
		"results/current/guppy/basecalled/fail/",
	threads: 
		config["guppy"]["num_callers"]
	resources:
		mem_mb=config["guppy"]["memory"]
	log: 
		"logs/guppy/basecalled/guppy.log"
	params:
		save_path="results/current/guppy/basecalled/",
		input_path=config["guppy"]["input_path"],
		flowcell=config["guppy"]["flowcell"],
		kit=config["guppy"]["kit"],
		num_callers=config["guppy"]["num_callers"],
		gpu_runners_per_device=config["guppy"]["gpu_runners_per_device"],
		chunks_per_runner=config["guppy"]["chunks_per_runner"],
		chunk_size=config["guppy"]["chunk_size"]	
	shell:
		"""guppy_basecaller --input_path {params.input_path} --save_path {params.save_path} --flowcell {params.flowcell} --kit {params.kit} --num_callers {params.num_callers} --gpu_runners_per_device {params.gpu_runners_per_device} --chunks_per_runner {params.chunks_per_runner} --chunk_size {params.chunk_size} --compress_fastq -x "cuda:0" --disable_pings 2>{log} """
