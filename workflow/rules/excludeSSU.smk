FASTQ_FILE = "results/current/downsampled_read_ids/{sample}.filtered.fastq"
REF_FILE = "pb-metagenomics-tools/Taxonomic-Profiling-Diamond-Megan/resources/current/ssu_all_r207.fna"
INDEX_FILE = "pb-metagenomics-tools/Taxonomic-Profiling-Diamond-Megan/resources/current/ssu_all_r207.mmi"

SAM_FILE = "results/current/downsampled/{sample}_mapped_reads.sam"
FASTQ_TEMP = "results/current/downsampled/{sample}.filtered.fastq"
FASTQ_OUT_FILE = "results/current/downsampled/{sample}.filtered.fastq.gz"

# Rule to create an index of the reference sequences using minimap2
rule index_ref:
    conda:
        "../envs/minimap2.yaml"
    threads:
        config["minimap2"]["threads"]
    input:
        REF_FILE
    output:
        INDEX_FILE
    log: "logs/index_ref/minimap.log"
    shell: "minimap2 -d {output} {input} 2>{log}"

# Rule to map the reads to the reference 16S sequences and extract the mapped reads
rule map_reads:
    conda:
        "../envs/minimap2.yaml"
    threads:
        config["minimap2"]["threads"]    
    input:
        FASTQ_FILE,
        INDEX_FILE
    output:
        SAM_FILE
    log: 
        "logs/map_reads/{sample}.log"
    params: 
         mapq=config["minimap2"]["mapq"],
    shell:
         '''minimap2 -t 3 -K5g -ax map-ont {input[1]} {input[0]} > {output} && samtools view -b -{params.mapq} -f 4 {output} > {output} 2>{log}'''

rule extract_fastq: 
   conda: 
        "../envs/minimap2.yaml"
   input: SAM_FILE
   output: FASTQ_TEMP
   shell: "samtools fastq {input} > {output}"

rule gzip: 
   input: FASTQ_TEMP
   output: FASTQ_OUT_FILE
   shell: "gzip -cvf {input} > {output}" 
