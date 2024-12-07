#!/bin/bash
# sample_list=( "a509" "s31222" )
# sample_list=( "s31222" "a509" "a509_2")
# sample_list=( "s31222" "a509_2" "a509_3")

# reference
refer_fasta_file=/public/home/xiayini/reference/chm13v2.0.name.fa
refer_repeat_bed_ch38=/public/home/xiayini/reference/human_GRCh38_no_alt_analysis_set.trf.bed

path=/public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis
#  需要最新版本的samtools
samtools=/public/home/xiayini/software/samtools/samtools-1.17/samtools
sample_str=""

sample_list=( "a509_2" "s31222" )

for sample in "${sample_list[@]}";do
    sample_str=${sample_str}_${sample}
done

makepath=$path/data/joint_multi/difference$sample_str
if [ ! -d "$makepath" ];then
    mkdir $makepath
fi



input_bam=$makepath/merge.sorted.bam
cache_bam=$makepath/merge.bam

output_vcf=$makepath/joint${sample_str}.vcf
# step1: samtools-sort
$samtools merge $cache_bam $path/data/${sample_list[0]}/merge.sorted.tag.bam $path/data/${sample_list[1]}/merge.sorted.tag.bam

# $samtools merge $cache_bam $path/data/${sample_list[@]}/merge.sorted.tag.bam
$samtools sort -o $input_bam $cache_bam
$samtools index $input_bam
rm $cache_bam
