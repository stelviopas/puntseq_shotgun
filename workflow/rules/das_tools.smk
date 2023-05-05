import glob 

rule harmonize_metabat:
	input:
		"results/current/metabat2/{sample}/{sample}"
	output:
		"results/current/metabat2/{sample}/{sample}.tsv"
	shell:
		"cp {input} {output}"

def get_fasta_bins(wildcards):
	dir = "results/current/maxbin2/{sample}/{sample}".format(sample = wildcards.sample)
	fastas = glob.glob(dir + "*.fasta")
	return fastas

rule harmonize_maxbin:
	input: fastas=dynamic(get_fasta_bins)
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

#########################################
def get_fna_bins(wildcards):
        dir = "results/current/vamb/{sample}/bins/filtered_bins/".format(sample = wildcards.sample)
        fnas = glob.glob(dir + "*.fna")
        return fnas

rule harmonize_vamb:
        input: fnas=dynamic(get_fna_bins) 
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
##########################################

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
	conda: "../envs/das_tool.yaml"
	threads: config["das_tool"]["threads"]
	input:
		metabat = "results/current/metabat2/{sample}/{sample}.tsv",
		maxbin = "results/current/maxbin2/{sample}/{sample}.tsv",
		vamb = "results/current/vamb/{sample}/bins/filtered_bins/{sample}.tsv",
		contigs = "results/current/medaka/{sample}.medaka1/assembly.fasta"
	output:
		"results/current/das_tool/{sample}/{sample}_DASTool_summary.txt"
	params:
		base_name = "results/current/das_tool/{sample}/{sample}"	
	log: "logs/das_tool/{sample}.txt"
	shell:
		"""
		DAS_Tool -i {input.metabat},{input.maxbin},{input.vamb} -l metabat,maxbin,vamb -c {input.contigs} -o {params.base_name}  --write_bins 1 --resume 1 -t {threads} > {log} 
		"""
