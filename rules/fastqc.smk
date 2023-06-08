rule fastqc:
    input:
       "results/current/minimap2/leptospira_interrogans_shotgun_new.sam" 
    output:
        html="results/current/fastqc/shotgun_new_leptospira_interrogans.html",
        zip="results/current/fastqc/shotgun_new_leptospira_interrogans_fastqc.zip" 
# the suffix _fastqc.zip is necessary for multiqc to find the file. If not using multiqc, you are free to choose an arbitrary filename
    params: 
	"--quiet"
    log:
        "logs/fastqc/shotgun_new_leptospira_interrogans.log"
    threads: config["fastqc"]["threads"] 
    wrapper:
        "v1.10.0/bio/fastqc"



