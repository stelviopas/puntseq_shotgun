# run this on GPU

rule medaka_consensus:
  conda: "../envs/medaka.yaml"
	threads: config["medaka"]["consensus_threads"]
	input:
		bam = "results/current/medaka/{sample}.medaka1/calls_to_draft.bam" 
	output:
		hdf = "results/current/medaka/{sample}.medaka1/contigs.hdf"
	log: "logs/medaka/{sample}.medaka1_consensus.txt"
        params:
                model = config["medaka"]["model"]
	shell:
		"""
		medaka consensus {input.bam} {output.hdf} --threads {threads} --model {params.model} --batch 200 >{log} 2>&1
		"""
