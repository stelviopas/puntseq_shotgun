rule harmonize_metabat:
	input:
		"results/current/metabat2/{sample}/{sample}"
	output:
		"results/current/metabat2/{sample}/{sample}.tsv"
	shell:
		"cp {input} {output}"

rule harmonize_maxbin:
	input: fastas=dynamic(expand("results/current/maxbin2/{{sample}}.{{maxbin_n}}.fasta"))
	output: "results/current/maxbin2/{sample}/{sample}.tsv"
	run: 
		import pandas as pd 
		
		bins = [] # right column
		contigs = [] # left column 
	
		for i, path2fasta in enumerate(input.fastas):
			with open(path2fasta, 'r') as file:
				for line in file: 
					if line[0] == '>':
						bins.append(i+1) # use 1-indexing
						contigs.append(line.lstrip(">").rstrip('\n')) # drop > and /n
		df = pd.DataFrame({'contigs': contigs, 'bins': bins})
		df.to_csv(output[0], sep='\t', header=False, index=False)					

rule harmonize_vamb:
        input: fnas=dynamic(expand("results/current/vamb/{{sample}}/bins/filtered_bins/{{vamb_n}}.fna")) 
        output: "results/current/vamb/{sample}/bins/filtered_bins/{sample}.tsv"
        run:
                import pandas as pd

                bins = [] # right column
                contigs = [] # left column

                for i, path2fasta in enumerate(input.fnas):
                        with open(path2fasta, 'r') as file:
                                for line in file:
                                        if line[0] == '>':
                                                bins.append(i+1) # use 1-indexing
                                                contigs.append(line.lstrip(">").rstrip('\n')) # drop > and /n
                df = pd.DataFrame({'contigs': contigs, 'bins': bins})
                df.to_csv(output[0], sep='\t', header=False, index=False)


# harmonizing all vamb bins leads to too big output which can not be processed by DAS_tool

'''
rule harmonize_all_vamb: 
	input: "results/current/vamb/{sample}/bins/clusters.tsv"
	output: "results/current/vamb/{sample}/bins/{sample}.tsv"
	run:
		import pandas as pd
		
		df = pd.read_csv(input[0], sep='\t', names=["bins","contigs"])
		df = df.reindex(columns=["contigs", "bins"])
		df.to_csv(output[0], sep='\t', header=False, index=False)	
'''
				
rule das_tool:
	conda: "das_tool"
	threads: config["das_tool"]["threads"]
	input:
		metabat = "results/current/metabat2/{sample}/{sample}.tsv",
		maxbin = "results/current/maxbin2/{sample}/{sample}.tsv",
		vamb = "results/current/vamb/{sample}/bins/filtered_bins/{sample}.tsv",
		contigs = "results/current/bioawk/{sample}/assembly.fasta"
	output:
		#directory("results/current/das_tool/{sample}/{sample}_DASTool_bins/"),
		#"results/current/das_tool/{sample}/{sample}_DASTool_summary.txt",
		dynamic("results/current/das_tool/{sample}/{sample}_DASTool_bins/{binner}.contigs.fa")		
	params:
		base_name = "results/current/das_tool/{sample}/{sample}"	
	#log: "logs/das_tool/{sample}_{binner}.txt"
	shell:
		"""
		DAS_Tool -i {input.metabat},{input.maxbin},{input.vamb} -l metabat,maxbin,vamb -c {input.contigs} -o {params.base_name}  --write_bins 1 --resume 1 -t {threads} > {log} 
		"""
