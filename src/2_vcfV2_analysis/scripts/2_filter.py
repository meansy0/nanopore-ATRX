import pysam
from multiprocessing import Pool

def process_chromosome(chr_num, sample_id):
    if chr_num >= 23:
        chr_num = 'X' if chr_num == 23 else 'Y'
    else:
        chr_num = str(chr_num)

    in_summary_path = f"{proj_path}/2_vcfV2_analysis/data/{sample_id}/chr{chr_num}_summary_second_align_filter.txt"
    fq = set(open(in_summary_path).read().splitlines())

    in_bam_path = f"{proj_path}/2_vcfV2_analysis/data/{sample_id}/chr{chr_num}.bam"
    out_bam_path = f"{proj_path}/2_vcfV2_analysis/data/{sample_id}/chr{chr_num}.filter.bam"

    infile = pysam.AlignmentFile(in_bam_path, 'rb')
    outfile = pysam.AlignmentFile(out_bam_path, "w", template=infile)

    for aln in infile:
        if aln.query_name in fq:
            outfile.write(aln)

    infile.close()
    outfile.close()

if __name__ == "__main__":

    num_processes = 5  # 设置同时处理的进程数
    sample_list=["s31222","a509","a509_2","a509_3"]
    # sample_list=["a509_3","s31222"]
    # sample_list=["a509","a509_2"]
    proj_path="/public/home/xiayini/project/nanopore_ATRX"
    chromosomes = list(range(1, 25))
    for sample_id in sample_list:
        with Pool(processes=num_processes) as pool:
            pool.starmap(process_chromosome, [(chr, sample_id) for chr in chromosomes])
