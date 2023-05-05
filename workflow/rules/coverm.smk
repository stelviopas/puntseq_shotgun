import glob 

def get_fa_bins(wildcards):
        dir = "results/current/das_tool/{sample}/{sample}_DASTool_bins/".format(sample = wildcards.sample)
        fas = glob.glob(dir + "*.fa")
        return fas

rule coverm:
	conda: "../envs/coverm.yaml"
	threads: config["coverm"]["threads"]
	input:
		reads = "results/current/downsampled/{sample}.filtered.fastq.gz",
		bins = dynamic(get_fa_bins)
	output:
		"results/current/coverm/{sample}_summary.txt"
	log: "logs/coverm/{sample}.txt"
	shell:
		"""
		coverm genome --single {input.reads} \
			-m relative_abundance -p minimap2-ont \
			--genome-fasta-files {input.bins} --genome-fasta-extension fa \
			--output-file {output} -t {threads} > {log} 
		"""
