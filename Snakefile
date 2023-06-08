# ======================================================
# Config files
# ======================================================
configfile: "config/config.yaml"

#======================================================
# Rules
#======================================================

ALL_SAMPLES = ["shotgun_new", "shotgun_fahad", "BC02_new", "BC03_new", "BC04_new", "BC02_porechop_fahad", "BC03_porechop_fahad", "BC04_porechop_fahad"]
#QC_SAMPLES = ["leptospira_interrogans_shotgun_new_q5", "leptospira_interrogans_shotgun_new_q10", "leptospira_interrogans_shotgun_new_q20", "leptospira_interrogans_shotgun_new_q30"] 
ASSEMBLY_SAMPLES = ["shotgun_new","shotgun_fahad"]
#MAPQ = ["q5", "q10", "q20", "q30"]

rule all:
	input:
##### FULL PIPELINE #####
# QC PLOTS
#		expand("results/current/nanoplot/{s}_NanoPlot-report.html", s=QC_SAMPLES),
# SHOTGUN
		expand("results/current/gtdbtk/{s}.bac120.summary.tsv", s=ASSEMBLY_SAMPLES),
		expand("results/current/vamb/{s}/bins/clusters.tsv", s=ASSEMBLY_SAMPLES),
		#expand("results/current/maxbin2/{s}/{s}.summary", s=ASSEMBLY_SAMPLES),
                #expand("results/current/metabat2/{s}/{s}", s=ASSEMBLY_SAMPLES),	
		expand("results/current/das_tool/{s}/{s}_DASTool_summary.txt", s=ASSEMBLY_SAMPLES),
		expand("results/current/coverm/{s}_summary.txt", s=ASSEMBLY_SAMPLES),
# ITOL TREE FOR HIGH-QULAITY ASSEMBLIES FROM DAS_TOOL
		expand("results/current/gtdbtk/{s}/classify/{s}_bac120_classify_itol.tree", s=ASSEMBLY_SAMPLES),
# 16S	
#		"results/current/amplicon/amplicon_new.fasta", "results/current/amplicon/amplicon_fahad.fasta",
# REFERENCE-BASED 
#		expand("results/current/reference_based_flye/leptospira_interrogans_shotgun_new_{q}/assembly.fasta", q=MAPQ)	
#########################



# the snakemake files that run the different parts of the pipeline
include: "rules/guppy.smk"
include: "rules/guppy_barcoder.smk"
include: "rules/porechop.smk"
include: "rules/nanoplot.smk"
include: "rules/fastqc.smk"
include: "rules/samtools.smk"
include: "rules/nanofilt.smk"
include: "rules/flye.smk"
include: "rules/map2reference.smk"
include: "rules/minimap2_raconX.smk"
include: "rules/medaka_1_align.smk"
include: "rules/medaka_2_consensus.smk"
include: "rules/medaka_3_stitch.smk"
include: "rules/bioawk.smk"
include: "rules/metabat2.smk"
include: "rules/vamb_workflow.smk"
include: "rules/maxbin2.smk"
include: "rules/filter_vamb_bins.smk"
include: "rules/das_tools.smk"
include: "rules/coverm.smk"
include: "rules/gtdbtk.smk"
