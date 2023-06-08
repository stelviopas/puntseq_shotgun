# TODO: uncapsule the filtering params to the main config file 
rule filter_vamb_bins: 
	input: 
		"results/current/vamb/{sample}/bins"
	output:
		dynamic("results/current/vamb/{sample}/bins/filtered_bins/{vamb_n}.fna")
		#"results/current/vamb/{sample}/bins/contig_lengths.csv"
	conda:
		"/home/haicu/anastasiia.grekova/workspace/puntseqWGS/.snakemake/conda/bcf94f93385041e0b445b5252ba5c7e5"
	script:
		"../scripts/filter_vamb_bins.py"	
