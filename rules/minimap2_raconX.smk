# for running racon multiple iterations 
# adapted from https://github.com/pmenzel/ont-assembly-snake/blob/master/Snakefile

rule minimap2_raconX:
  conda: "../envs/racon_minimap2.yaml"
	threads: config["racon"]["threads"]
	input:
		prev_fa = "results/current/flye/{sample}/assembly.fasta",
		fq = "results/current/nanofilt/{sample}.filtered.fastq.gz"
	output:
		fa = "results/current/racon/{sample}.racon{num}/assembly.fasta",
		link = "results/current/racon/{sample}.racon{num}.fasta"
	params:
		dir = "results/current/racon/"
	log: "logs/racon/{sample}.racon{num}.txt"
	shell:
		"""
		DIR_temp=$(mktemp -d --suffix=.raconX --tmpdir={params.dir})
		trap "rm -r $DIR_temp" EXIT
		cp {input.prev_fa} $DIR_temp/prev.fa
		for i in `seq 1 {wildcards.num}`
		do
			echo "Polishing round $i / {wildcards.num}" >>{log}
			minimap2 -ax map-ont -t {threads} $DIR_temp/prev.fa {input.fq} > $DIR_temp/map.sam 2>>{log}
			racon --threads {threads} --include-unpolished {input.fq} $DIR_temp/map.sam $DIR_temp/prev.fa > $DIR_temp/polished.fa 2>>{log}
			mv $DIR_temp/polished.fa $DIR_temp/prev.fa
		done
		mv $DIR_temp/prev.fa {output.fa}
		ln -sr {output.fa} {output.link}
		"""
