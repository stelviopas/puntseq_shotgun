rule downsample_shotgun:
    threads:
                config["nanofilt"]["threads"]
    input: expand("results/current/nanofilt/{sample}.filtered.fastq.gz", sample=["shotgun_new", "shotgun_fahad"])
    output: expand("results/current/downsampled_read_ids/{sample}.filtered.fastq", sample=["shotgun_new", "shotgun_fahad"])
    log: "logs/downsample.log"
    script: "../scripts/downsample.py"
        
