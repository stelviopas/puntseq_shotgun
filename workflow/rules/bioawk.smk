rule bioawk:
  conda: "bioawk"
	input:
		fa = "resources/{sample}.fasta"
	output:
		fa = "results/current/bioawk/{sample}/assembly.fasta"
	params:
		min_contig_length = config["bioawk"]["min_contig_length"]
	log: "logs/bioawk/{sample}_filtered.txt"
	shell:
		"""
		bioawk -cfastx 'BEGIN{{ shorter = 0}} {{if (length($seq) < {params.min_contig_length}) shorter += 1}} END {{print "contigs shorter than {params.min_contig_length} kb BEFORE filtering:", shorter}}' {input.fa} >{log} 2>&1
		bioawk -c fastx '{{ if(length($seq) > {params.min_contig_length}) {{ print ">"$name; print $seq }}}}' {input.fa} > {output.fa}
		bioawk -cfastx 'BEGIN{{ shorter = 0}} {{if (length($seq) < {params.min_contig_length}) shorter += 1}} END {{print "contigs shorter than {params.min_contig_length} kb AFTER filtering:", shorter}}' {output.fa} >>{log} 2>&1
		"""
