# TODO: uncapsule the filtering params to the main config file 
rule filter_vamb_bins: 
	input: 
		"results/current/vamb/{sample}/bins"
	output:
		#"results/current/vamb/{sample}/bins/filtered_bins/",
		"results/current/vamb/{sample}/bins/contig_lengths.csv"
	conda:
		"../envs/vamb_pandas.yaml"
	script:
		"../scripts/filter_vamb_bins.py"	
