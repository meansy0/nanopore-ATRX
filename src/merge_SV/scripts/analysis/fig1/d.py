# vcf2fasta
# fasta->cg rate
# 新生sv的cg含量 ：result 没有上升趋势
from Bio import SeqIO
import pandas as pd
from Bio import SeqIO

import pandas as pd

def read_vcf_to_fasta(vcf_filename, fasta_output_filename):
    # 读取VCF文件
    vcf_df = pd.read_csv(vcf_filename, sep='\t', comment='#', header=None, 
                         names=['CHROM', 'POS', 'ID', 'REF', 'ALT', 'QUAL', 'FILTER', 'INFO', 'FORMAT', 'SAMPLE'])

    # 打开文件以写入FASTA格式的序列
    with open(fasta_output_filename, 'w') as fasta_file:
        for index, row in vcf_df.iterrows():
            if ("INS" in row['ID']):
                header = f">{row['CHROM']}_{row['POS']}_{row['ID']}"
                sequence = row['ALT']  # 使用变异序列（ALT列）
                fasta_file.write(f"{header}\n{sequence}\n")


def calculate_cg_content(fasta_file):
    # List to store CG content for each record
    cg_contents = []

    # Read the fasta file
    for record in SeqIO.parse(fasta_file, "fasta"):
        seq = str(record.seq).upper()
        cg_count = seq.count('C') + seq.count('G')+seq.count('c')+seq.count('g')
        cg_content = cg_count / len(seq) * 100  # CG content as a percentage
        cg_contents.append(cg_content)
        # print(f"Record {record.id} has CG content: {cg_content}%")

    # Calculate the average CG content
    average_cg_content = sum(cg_contents) / len(cg_contents)
    print(f"Average CG Content: {average_cg_content}%")
    return cg_contents, average_cg_content





# Replace 'path_to_your_fasta_file.fasta' with your actual FASTA file path
sample_list=[ "a509_s31222", "s31222_a509_a509_2","s31222_a509_2_a509_3" ]
for group in sample_list:
    # vcf2fasta
    vcf_filename=f"/public/home/xiayini/project/nanopore_ATRX/merge_SV/data/joint_multi_supReads2/difference_{group}/cutesv.filter.1.read.vcf"
    
    print(group)
    fasta_output_filename = f'/public/home/xiayini/project/nanopore_ATRX/merge_SV/results/analysis/fig1/b_{group}_sv.fasta'  # 输出FASTA文件的路径
    read_vcf_to_fasta(vcf_filename, fasta_output_filename)

    calculate_cg_content(fasta_output_filename)
