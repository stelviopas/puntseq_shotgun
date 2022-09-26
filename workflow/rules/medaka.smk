# for running racon multiple iterations 
# adapted from https://github.com/pmenzel/ont-assembly-snake/blob/master/Snakefile

rule medakaX:
  conda: "../envs/medaka.yaml"
	threads: config["medaka"]["threads"]
	input:
		prev_fa = "results/current/racon/{sample}.racon3./assembly.fasta",
		fq = "results/current/nanofilt/{sample}.filtered.fastq.gz"
	output:
		fa = "results/current/medaka/{sample}.medaka{m_num}/assembly.fasta",
		link = "results/current/medaka/{sample}.medaka{m_num}.fasta"
	log: "logs/medaka/{sample}.medaka{m_num}.txt"
        params:
                model = config["medaka"]["model"]
	shell:
		"""
		DIR_temp=".medakaX"
                #mkdir $DIR_temp
		trap "rm -r $DIR_temp" EXIT
		#cp {input.prev_fa} $DIR_temp/prev.fa
		for i in `seq 1 {wildcards.m_num}`
		do
			echo "Polishing round $i / {wildcards.m_num}" >>{log}
			medaka_consensus -t {threads} -m {params.model} -d $DIR_temp/prev.fa -i {input.fq} -o $DIR_temp/polished.fa >{log} 2>&1
			mv $DIR_temp/polished.fa $DIR_temp/prev.fa
		done
		mv $DIR_temp/prev.fa {output.fa}
		ln -sr {output.fa} {output.link}
		"""
