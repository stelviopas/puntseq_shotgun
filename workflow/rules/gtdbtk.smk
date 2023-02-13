import glob 

def get_fa_bins(wildcards):
        dir = "results/current/das_tool/{sample}/{sample}_DASTool_bins/".format(sample = wildcards.sample)
        fas = glob.glob(dir + "*.fa")
        return fas

rule gtdbtk:
	# TODO the envrionemnt invokes download.sh script which downloades dbs and needs to be configured manually 
# therefore the environment can not be installed completely automatically 
	conda: "../envs/gtdbtk-2.1.1.yaml"
	threads: config["gtdbtk"]["threads"]
	input:
		bins = get_fa_bins, 
		dir = "results/current/das_tool/{sample}/{sample}_DASTool_bins/",
		db = config["gtdbtk"]["db"]
	output:
		dir=directory("results/current/gtdbtk/{sample}")
	log: "logs/gtdbtk/{sample}.txt"
	shell:
		"""
		export GTDBTK_DATA_PATH={input.db}
		gtdbtk classify_wf --genome_dir {input.dir} --extension fa \
				--prefix {wildcards.sample} --cpus {threads} \
				--out_dir {output.dir} --full_tree >> {log}
		"""
