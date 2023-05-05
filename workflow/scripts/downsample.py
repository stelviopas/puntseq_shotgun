import gzip
from Bio import SeqIO

def downsample(input_file1, input_file2, output_file1, output_file2):
    seq_ids = set()
    # Collect sequence IDs from the first file
    with gzip.open(input_file1, "rt") as f1:
        for record in SeqIO.parse(f1, "fastq"):
            seq_ids.add(record.id)
    # Collect overlapping sequence IDs from the second file
    overlapping_ids = set()
    with gzip.open(input_file2, "rt") as f2:
        for record in SeqIO.parse(f2, "fastq"):
            if record.id in seq_ids:
                overlapping_ids.add(record.id)
    # Write the downsampled sequences to output files
    with open(output_file1, "wt") as out1, open(output_file2, "wt") as out2:
        with gzip.open(input_file1, "rt") as f1:
            for record in SeqIO.parse(f1, "fastq"):
                if record.id in overlapping_ids:
                    SeqIO.write(record, out1, "fastq")
        with gzip.open(input_file2, "rt") as f2:
            for record in SeqIO.parse(f2, "fastq"):
                if record.id in overlapping_ids:
                    SeqIO.write(record, out2, "fastq")
    print("# of overlapping IDs:", len(overlapping_ids))

downsample(input_file1 = "/home/grekova/workspace/puntseq_shotgun/results/current/nanofilt/shotgun_fahad.filtered.fastq.gz", 
            input_file2 = "/home/grekova/workspace/puntseq_shotgun/results/current/nanofilt/shotgun_new.filtered.fastq.gz", 
            output_file1 = "/home/grekova/workspace/puntseq_shotgun/results/current/downsampled_read_ids/shotgun_fahad.filtered.fastq", 
            output_file2 = "/home/grekova/workspace/puntseq_shotgun/results/current/downsampled_read_ids/shotgun_new.filtered.fastq")
