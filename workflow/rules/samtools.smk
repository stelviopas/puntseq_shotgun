rule samtools:
  conda: "../envs/samtools.yaml"
	input:
		"results/current/minimap2/leptospira_interrogans_shotgun_new.sam"
	output:
		"results/current/samtools/leptospira_interrogans_shotgun_new.fastq"
	log: "logs/samtools/leptospira_interrogans_shotgun_new.txt"
	shell:
		"""
		samtools view -b -q5 {input} > filtered.bam
		samtools fastq filtered.bam -F 4 > {output}
		"""
