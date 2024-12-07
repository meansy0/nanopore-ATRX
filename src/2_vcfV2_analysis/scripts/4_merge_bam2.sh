#!/bin/bash				
#SBATCH -J merge_bam2
#SBATCH -N 1							
#SBATCH -p normal		
#SBATCH --mem 256g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err


# sample_list=( "a509" "s31222" )
# all_all_sample_list=( "s31222" "a509" "a509_2" "a509_3" )
sample_list=( "s31222" "a509_2" "a509_3")
path=/public/home/xiayini/project/nanopore_ATRX/2_vcfV2_analysis
samtools=/public/home/xiayini/software/samtools/samtools-1.17/samtools


# # !!!!! just once
# for sample in "${all_all_sample_list[@]}";do
#     $samtools merge $path/data/$sample/all.bam $path/data/$sample/chr*.filter.tag.bam
# done

#  需要最新版本的samtools

sup_reads=2
sample_str=""

for sample in "${sample_list[@]}";do
    sample_str=${sample_str}_${sample}
done


if [ $sup_reads -eq 2 ];then
    makepath=/public/home/xiayini/project/nanopore_ATRX/2_vcfV2_analysis/data/joint_multi_supReads2/difference$sample_str
else
    makepath=/public/home/xiayini/project/nanopore_ATRX/2_vcfV2_analysis/data/joint_multi/difference$sample_str

fi
if [ ! -d "$makepath" ];then
    mkdir -p $makepath
fi



output_bam=$makepath/all.merge.bam
cache_bam=$makepath/cache.merge.bam

if [ ${#sample_list[@]} -eq 2 ]; then
# step1: samtools-sort
    # $samtools merge merged.bam chr*.bam
    $samtools merge $cache_bam $path/data/${sample_list[0]}/all.bam $path/data/${sample_list[1]}/all.bam
else
    $samtools merge $cache_bam $path/data/${sample_list[0]}/all.bam $path/data/${sample_list[1]}/all.bam $path/data/${sample_list[2]}/all.bam
fi

$samtools sort -o $output_bam $cache_bam
$samtools index $output_bam
rm $cache_bam
