#!/bin/bash				
#SBATCH -J a509_3_samtools		
#SBATCH -N 2							
#SBATCH -p normal		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err


# sample_list=( "a509" "s31222" )
# sample_list=( "s31222" "a509" "a509_2")
# sample_list=( "s31222" "a509_2" "a509_3")

# reference
refer_fasta_file=/public/home/xiayini/reference/chm13v2.0.name.fa
refer_repeat_bed_ch38=/public/home/xiayini/reference/human_GRCh38_no_alt_analysis_set.trf.bed

path=/public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis

out_path=/public/home/xiayini/project/nanopore_ATRX/2_vcfV3_analysis

#  需要最新版本的samtools
samtools=/public/home/xiayini/software/samtools/samtools-1.17/samtools
sample_str=""

sample_list=( "s31222" "a509_3" )

for sample in "${sample_list[@]}";do
    sample_str=${sample_str}_${sample}
done

makepath=$out_path/data/joint_multi/difference$sample_str
if [ ! -d "$makepath" ];then
    mkdir -p $makepath
fi



input_bam=$makepath/merge.sorted.bam
cache_bam=$makepath/merge.bam

# step1: samtools-sort
$samtools merge $cache_bam $path/data/${sample_list[0]}/merge.sorted.tag.bam $path/data/${sample_list[1]}/merge.sorted.tag.bam

# $samtools merge $cache_bam $path/data/${sample_list[@]}/merge.sorted.tag.bam
$samtools sort -o $input_bam $cache_bam
$samtools index $input_bam
rm $cache_bam
