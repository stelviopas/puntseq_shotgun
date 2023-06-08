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
		bins = dynamic(get_fa_bins), 
		dir = directory("results/current/das_tool/{sample}/{sample}_DASTool_bins/"),
		db = config["gtdbtk"]["db"]
	output:
		"results/current/gtdbtk/{sample}.bac120.summary.tsv",
		"results/current/gtdbtk/{sample}/classify/{sample}.bac120.classify.tree"
	params: dir="results/current/gtdbtk/{sample}"
	log: "logs/gtdbtk/{sample}.txt"
	shell:
		"""
		export GTDBTK_DATA_PATH={input.db}
		gtdbtk classify_wf --genome_dir {input.dir} --extension fa \
				--prefix {wildcards.sample} --cpus {threads} \
				--out_dir {params.dir} >> {log}
		"""
rule convert_to_itol: 
        conda: "../envs/gtdbtk-2.1.1.yaml"
        threads: config["gtdbtk"]["threads"]
	input: "results/current/gtdbtk/{sample}/classify/{sample}.bac120.classify.tree"
        output: "results/current/gtdbtk/{sample}/classify/{sample}_bac120_classify_itol.tree"
	log: "logs/gtdbtk_convert_to_itol/{sample}.txt"
        shell:  
                """
                gtdbtk convert_to_itol --input {input} --output {output}
                """
