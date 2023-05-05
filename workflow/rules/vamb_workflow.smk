rule cat_contigs:
    input:
       "results/current/bioawk/{sample}.medaka1_filtered/assembly.fasta" 
    output:
        "results/current/vamb/{sample}/contigs.flt.fna.gz"
    params:
        walltime="864000", nodes="1", ppn="1", mem="10gb", min_contig_length=config["bioawk"]["min_contig_length"]
    threads:
        int(1)
    log:
        "logs/contigs/{sample}/catcontigs.log"
    conda:
        "../envs/vamb.yaml"
    shell:
# dummy function because we only have 1 sample 
        "cp {input} {output}"

rule index:
    input:
        contigs = "results/current/vamb/{sample}/contigs.flt.fna.gz"
    output:
        mmi = "results/current/vamb/{sample}/contigs.flt.mmi"
    params:
        walltime="864000", nodes="1", ppn="1", mem="90gb", index_size=config["vamb_workflow"]["index_size"]
    threads:
        int(1)
    log:
        "logs/contigs/{sample}/index.log"
    conda: 
        "../envs/minimap2.yaml"
    shell:
        "minimap2 -I 64G -d {output} {input} 2> {log}"

rule dict:
    input:
        contigs = "results/current/vamb/{sample}/contigs.flt.fna.gz"
    output:
        dict = "results/current/vamb/{sample}/contigs.flt.dict"
    params:
        walltime="864000", nodes="1", ppn="1", mem="10gb"
    threads:
        int(1)
    log:
        "logs/contigs/{sample}/dict.log"
    conda:
        "../envs/samtools.yaml"
    shell:
        "samtools dict {input} | cut -f1-3 > {output} 2> {log}"

rule minimap:
    input:
        fq = "results/current/downsampled/{sample}.filtered.fastq.gz",
        mmi = "results/current/vamb/{sample}/contigs.flt.mmi",
        dict = "results/current/vamb/{sample}/contigs.flt.dict"
    output:
        bam = "results/current/vamb/{sample}/mapped/{sample}.bam"
    params:
        walltime="864000", nodes="1", ppn=10, mem="35gb"
    threads:
        int(10)
    log:
        "logs/map/{sample}.minimap.log"
    conda:
        "../envs/minimap2.yaml"
    shell:
        '''minimap2 -t {threads} -I 64G -ax sr {input.mmi} {input.fq} -N 5 | grep -v "^@" | cat {input.dict} - | samtools view -F 3584 -b - > {output.bam} 2>{log}'''

rule sort:
    input:
        "results/current/vamb/{sample}/mapped/{sample}.bam"
    output:
        "results/current/vamb/{sample}/mapped/{sample}.sort.bam"
    params:
        walltime="864000", nodes="1", ppn="2", mem="15gb",
        prefix="results/current/vamb/{sample}/mapped/tmp.{sample}"
    threads:
        int(2)
    log:
        "logs/map/{sample}.sort.log"
    conda:
        "../envs/samtools.yaml"
    shell:
        "samtools sort {input} -T {params.prefix} --threads {threads} -m 20G -n -o {output} 2>{log}"

rule vamb:
    conda:
        "../envs/vamb.yaml"
    input:
        catalog = "results/current/bioawk/{sample}.medaka1_filtered/assembly.fasta", 
        bam = "results/current/vamb/{sample}/mapped/{sample}.sort.bam" 
    output:
        "results/current/vamb/{sample}/bins/clusters.tsv",
        "results/current/vamb/{sample}/bins/latent.npz",
        "results/current/vamb/{sample}/bins/lengths.npz",
        "results/current/vamb/{sample}/bins/log.txt",
        "results/current/vamb/{sample}/bins/model.pt",
        "results/current/vamb/{sample}/bins/mask.npz",
        "results/current/vamb/{sample}/bins/tnf.npz",
    params: dir = "results/current/vamb/{sample}"
    log:
        "logs/vamb/{sample}/vamb.log"
    shell:
        """
           vamb --outdir {params.dir}/out --fasta {input.catalog} --bamfiles {input.bam} 2>{log}
           mv {params.dir}/out/* {params.dir}/bins
           rm -r {params.dir}/out
	"""
