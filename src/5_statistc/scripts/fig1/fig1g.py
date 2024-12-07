import pysam


def gcCounts(sample,type):
# 读取 VCF 文件
    
    path=f'/public/home/xiayini/project/nanopore_ATRX/2_vcfV3_analysis/data/joint_multi/'
    vcf_file = f'{path}difference_{sample}/cutesv.filter.{str(type)}.read.vcf'
    # chr start end strain id type
    bed_file=f'{path}difference_{sample}/GC_count.{str(type)}.bed'
    with pysam.VariantFile(vcf_file, "r") as vcf_in,open(bed_file,'w') as bed_out:
    # 遍历每条信息并计算 GC 含量
        for record in vcf_in:
            ref_sequence = record.ref
            alt_sequence = ','.join(map(str, record.alts))

            # 合并 REF 和 ALT 序列
            sequence = ref_sequence + alt_sequence
            sc_type=record.id.split('.')[1]
            # 计算 GC 含量
            gc_content = (sequence.count('G') + sequence.count('C')+sequence.count('g') + sequence.count('c')) / float(len(sequence)) * 100
            strain='+' if record.info.get('STRAND', '+') == '+' else '-'
            # 输出结果
            bed_out.write(f'{record.chrom}\t{str(record.pos)}\t{str(record.pos + len(record.ref) - 1)}\t{strain}\t{gc_content:.2f}\t{sc_type}\n')
            # print(f"Variant: {record.chrom}:{record.pos}, GC Content: {gc_content:.2f}%")

    # 关闭
    #  VCF 文件
    vcf_in.close()
    bed_out.close()
    print(bed_file)


def main():
    sample='s31222_a509'
    gcCounts(sample,type=1)


if __name__=='__main__':
    main()