rule samtools:
  conda: "samtools"
	input:
		"results/current/minimap2/leptospira_interrogans_shotgun_new.sam"
	output:
		"results/current/samtools/leptospira_interrogans_shotgun_new_{mapq}.fastq"
	log: "logs/samtools/leptospira_interrogans_shotgun_new_{mapq}.txt"
	shell:
		"""
		samtools view -b -{wildcards.mapq} {input} > filtered_{wildcards.mapq}.bam
		samtools fastq filtered_{wildcards.mapq}.bam -F 4 > {output}
		"""
