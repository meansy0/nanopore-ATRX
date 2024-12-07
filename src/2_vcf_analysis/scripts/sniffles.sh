#!/bin/bash				
#SBATCH -J sniffleA509_2			
#SBATCH -N 1							
#SBATCH -p normal		
#SBATCH --mem 128g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err


# reference
refer_fasta_file=/public/home/xiayini/reference/chm13v2.0.name.fa
refer_repeat_bed_ch38=/public/home/xiayini/reference/human_GRCh38_no_alt_analysis_set.trf.bed

# sample infor
sample_id=a509_2
up_pipleline_path=/public/home/xiayini/project/nanopore_ATRX/1_upstream_analysis
pipleline_path=/public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis

# input
input_path=$pipleline_path/data/$sample_id
input_bam=$input_path/merge.sorted.bam
input_bam_bai=$input_path/merge.sorted.bam.bai
# 判断目标文件夹是否存在
if [ ! -d "$input_path" ]; then
# 如果文件夹不存在，则创建它
    mkdir -p "$input_path"
    ln -s $up_pipleline_path/results/$sample_id/merge.sorted.bam $input_path
    ln -s $up_pipleline_path/results/$sample_id/merge.sorted.bam.bai $input_path
fi


# output
output_path=$pipleline_path/results/$sample_id
output_vcf=$output_path/${sample_id}_sniffle.vcf
# 判断目标文件夹是否存在
if [ ! -d "$output_path" ]; then
# 如果文件夹不存在，则创建它
    mkdir -p "$output_path"
fi

# sniffle
sniffles --input $input_bam --reference $refer_fasta_file --tandem-repeats $refer_repeat_bed_ch38 --vcf $output_vcf