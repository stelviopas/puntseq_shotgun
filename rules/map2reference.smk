rule minimap2_sam_sorted:
    input:
        query="results/current/nanofilt/shotgun_new.filtered.fastq.gz",
	#target="resources/databases/references/aliarcobacter_cryaerophilus/GCF_003660105.1/GCF_003660105.1_ASM366010v1_genomic.fna"
        target="resources/databases/references/leptospira_interrogans/GCF_002073495.2/GCF_002073495.2_ASM207349v2_genomic.fna",
    output:
        "results/current/minimap2/leptospira_interrogans_shotgun_new.sam",
    log:
        "logs/minimap2/leptospira_interrogans_shotgun_new.log",
    params:
        extra="-ax map-ont",
        sorting="coordinate",  # optional: Enable sorting. Possible values: 'none', 'queryname' or 'coordinate'
    threads:
        config["minimap2"]["threads"] 
    wrapper:
        "v1.21.4/bio/minimap2/aligner"

