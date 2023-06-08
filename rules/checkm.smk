shell.executable("/bin/bash")

from snakemake.utils import min_version
min_version("5.0")

import os

configfile: "config.json"

IDS, = glob_wildcards("mags/{id}.fa")

rule all:
         input: "sourmash_report.csv", "phylophlan_out", "diamond_bin_report_plus.tsv", expand("pfam/{sample}.pfam", sample=IDS), expand("diamond_report/bin.{sample}.tsv", sample=IDS), "checkm_plus.txt"


rule checkm:
        input: "mags"
        output: "checkm.txt"
        threads: 36
        conda: "envs/checkm.yaml"
        params:
                cdr=config["checkm_dataroot"]
        shell:
                '''
                checkm_db={params.cdr}
                echo ${{checkm_db}} | checkm data setRoot ${{checkm_db}}
                checkm lineage_wf -f checkm.txt --reduced_tree -t {threads} -x fa {input} ./checkm
                '''
rule checkm_plus:
        input: "checkm.txt"
        output: "checkm_plus.txt"
        threads: 1
        conda: "envs/ete3.yaml"
        shell: "scripts/add_tax.py {input} > {output}"
