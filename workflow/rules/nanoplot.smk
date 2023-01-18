def get_nanoplot_input_fastqs(wildcards):
	return config["qc_input"][wildcards.suffix]	

rule nanoplot:
        input:
               get_nanoplot_input_fastqs
        output:
               multiext("results/current/nanoplot/{suffix}_", "LengthvsQualityScatterPlot_dot.html", "LengthvsQualityScatterPlot_dot.png", "LengthvsQualityScatterPlot_kde.html", "LengthvsQualityScatterPlot_kde.png", "NanoPlot-report.html", "NanoStats.txt", "Non_weightedHistogramReadlength.html", "Non_weightedHistogramReadlength.png", "Non_weightedLogTransformed_HistogramReadlength.html", "Non_weightedLogTransformed_HistogramReadlength.png", "WeightedHistogramReadlength.html", "WeightedHistogramReadlength.png", "WeightedLogTransformed_HistogramReadlength.html", "WeightedLogTransformed_HistogramReadlength.png", "Yield_By_Length.html", "Yield_By_Length.png")
        threads:
                config["nanoplot"]["threads"]
        resources:
                mem_mb=config["nanoplot"]["memory"]
        log:
                "logs/nanoplot/{suffix}.log"
        conda:
                "../envs/nanoplot.yaml"
        shell:
                "NanoPlot --fastq {input} --outdir results/current/nanoplot/ --prefix {wildcards.suffix}_  "
		"-t {threads} --tsv_stats --store --N50 --title {wildcards.suffix} --format png" 
