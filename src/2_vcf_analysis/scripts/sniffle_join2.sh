#!/bin/bash				
#SBATCH -J sniffle_joint2			
#SBATCH -N 1							
#SBATCH -p normal		
#SBATCH --mem 128g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err


# reference
refer_fasta_file=/public/home/xiayini/reference/chm13v2.0.name.fa
refer_repeat_bed_ch38=/public/home/xiayini/reference/human_GRCh38_no_alt_analysis_set.trf.bed

path=/public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis
#  需要最新版本的samtools
samtools=/public/home/xiayini/software/samtools/samtools-1.17/samtools
sample_str=""

sample_list=( "a509" "a509_2" )

for sample in "${sample_list[@]}";do
    sample_str=${sample_str}_${sample}

done


input_bam=$path/data/joint_multi/merge.sorted.bam
cache_bam=$path/data/joint_multi/merge.bam

output_vcf=$path/data/joint_multi/joint_${sample_str}.vcf


# sniffle
sniffles --input $input_bam --reference $refer_fasta_file --tandem-repeats $refer_repeat_bed_ch38 --vcf $output_vcf --output-rnames
