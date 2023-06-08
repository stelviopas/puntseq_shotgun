import vamb 
import os
import pandas as pd 

def filterclusters(clusters, lengthof, minbinsize=200000):
    filtered_bins = dict()
    for medoid, contigs in clusters.items():
        binsize = sum(lengthof[contig] for contig in contigs)
    
        if binsize >= minbinsize:
            filtered_bins[medoid] = contigs
    
    return filtered_bins 

def save_bins(path2vamb, maxbins, filter=False, lengths_to_csv=False):
	with vamb.vambtools.Reader(os.path.join(path2vamb.replace("bins/",""), 'contigs.flt.fna.gz'), 'rb') as filehandle:
		fastadict = vamb.vambtools.loadfasta(filehandle)

	with open(os.path.join(path2vamb + 'clusters.tsv'), 'r') as fileclusters:
		contignames = []
		for line in fileclusters:
			contigname = line.split('\t')[1].strip()
			contignames.append(contigname)

	with open(os.path.join(path2vamb + 'clusters.tsv'), 'r') as fileclusters:
		clusters = vamb.cluster.read_clusters(fileclusters, min_size=1)

	lengths = vamb.vambtools.read_npz(os.path.join(path2vamb + 'lengths.npz'))
	lengthof = dict(zip(contignames, lengths))

	if lengths_to_csv: 
		df = pd.DataFrame({'contignames': contignames, 'lengths' : lengths})
		df.to_csv(os.path.join(path2vamb, 'contig_lengths.csv'))
			
	if filter:
		filtered_bins = filterclusters(clusters, lengthof, minbinsize=50000)
	else: 
		filtered_bins = clusters
	print("Bins saved: ", len(filtered_bins))
	vamb.vambtools.write_bins(os.path.join(path2vamb, 'filtered_bins'), filtered_bins, fastadict, maxbins=maxbins)

path2vamb = '/home/haicu/anastasiia.grekova/workspace/MAG_pipeline_air/results/current/vamb/bins'
save_bins(path2vamb, maxbins = 50000, filter=True, lengths_to_csv=True)
