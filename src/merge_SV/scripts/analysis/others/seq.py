import pysam
import csv
# /public/home/xiayini/anaconda3/envs/cuteSV/bin/python3

# 路径到您的VCF和FASTA文件
vcf_path = '/public/home/xiayini/project/nanopore_ATRX/merge_SV/data/joint_multi_supReads2/difference_s31222_a509_2_a509_3/cutesv.filter.1.read.vcf'
fasta_path = '/public/home/xiayini/reference/chm13v2.0.name.fa'

# 输出CSV文件路径
output_csv_path = '/public/home/xiayini/project/nanopore_ATRX/merge_SV/scripts/analysis/others/output.csv'

# 打开FASTA文件和VCF文件
fasta = pysam.FastaFile(fasta_path)
vcf = pysam.VariantFile(vcf_path)

# 创建并打开CSV文件进行写入
with open(output_csv_path, mode='w', newline='') as file:
    writer = csv.writer(file)
    # 写入标题行
    writer.writerow(['Chromosome', 'Start', 'End', 'Upstream 10bp', 'SV Sequence', 'Downstream 10bp', 'SV Type'])

    # 遍历VCF中的记录
    for record in vcf:
        chrom = record.chrom
        start = record.start  # SV的起始位置
        end = record.stop    # SV的结束位置
        sv_type = record.info['SVTYPE'] if 'SVTYPE' in record.info else 'N/A'  # 获取SV类型

        # 提取上游和下游10bp的序列
        # Adjust start position to avoid negative values
        adjusted_start = max(0, start - 10)
        upstream_seq = fasta.fetch(chrom, adjusted_start, start)
        # 使用try-except结构来提取上游和下游10bp的序列，并处理可能出现的异常
        try:
            # 为避免提取负坐标，对起始位置进行调整
            adjusted_start = max(0, start - 10)
            upstream_seq = fasta.fetch(chrom, adjusted_start, start)
            downstream_seq = fasta.fetch(chrom, end, end + 10)
            # 对于SV序列，我们假设它存在于start和end之间
            sv_seq = fasta.fetch(chrom, start, end)
        except ValueError as e:
            print(f"Error fetching sequence for {chrom}:{start}-{end}: {e}")
            continue  # 遇到错误时跳过当前记录


        upstream_seq = fasta.fetch(chrom, start - 10, start)
        downstream_seq = fasta.fetch(chrom, end, end + 10)

        # 提取SV的序列
        sv_seq = fasta.fetch(chrom, start, end)

        # 写入记录到CSV文件
        writer.writerow([chrom, start, end, upstream_seq, sv_seq, downstream_seq, sv_type])
