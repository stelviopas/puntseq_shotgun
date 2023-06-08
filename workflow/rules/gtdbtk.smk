rule gtdbtk:
	# TODO the envrionemnt invokes download.sh script which downloades dbs and needs to be configured manuall
	# therefore the environment can not be installed completely automatically 
	conda: "gtdbtk-2.1.1"
	threads: config["gtdbtk"]["threads"]
	input:
		bins = dynamic(expand("results/current/das_tool/{{sample}}/{{sample}}_DASTool_bins/{{binner}}.contigs.fa")),
		db = config["gtdbtk"]["db"]
	output:
		"results/current/gtdbtk/{sample}.bac120.summary.tsv",
		"results/current/gtdbtk/{sample}/classify/{sample}.bac120.classify.tree"
	params: 
		dir="results/current/gtdbtk/{sample}",
		input_dir="results/current/das_tool/{sample}/{sample}_DASTool_bins/"
	log: "logs/gtdbtk/{sample}.txt"
	shell:
		"""
		export GTDBTK_DATA_PATH={input.db}
		gtdbtk classify_wf --genome_dir {params.input_dir} --extension fa \
				--prefix {wildcards.sample} --cpus {threads} \
				--out_dir {params.dir} --full_tree >> {log}
		"""
rule convert_to_itol: 
        conda: "gtdbtk-2.1.1"
        threads: config["gtdbtk"]["threads"]
	input: "results/current/gtdbtk/{sample}/classify/{sample}.bac120.classify.tree"
        output: "results/current/gtdbtk/{sample}/classify/{sample}_bac120_classify_itol.tree"
	log: "logs/gtdbtk_convert_to_itol/{sample}.txt"
        shell:  
                """
                gtdbtk convert_to_itol --input {input} --output {output}
                """
