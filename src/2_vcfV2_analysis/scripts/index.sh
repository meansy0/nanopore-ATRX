#!/bin/bash				
#SBATCH -J index
#SBATCH -N 1							
#SBATCH -p normal		
#SBATCH --mem 256g

samtools=/public/home/xiayini/software/samtools/samtools-1.17/samtools

proj_path=/public/home/xiayini/project/nanopore_ATRX
cd $proj_path

sample_list=("a509_3" "s31222")
for sample_id in "${sample_list[@]}";do
    for ((chr=1; chr<=24; chr++)); do
    {
        if [ $chr -ge 23 ]; then
            if [ $chr -eq 23 ]; then
                chr_num=X
            else
                chr_num=Y
            fi
        else
            chr_num=$chr
        fi
    chr_bam_file=2_vcfV2_analysis/data/${sample_id}/chr${chr_num}.bam
    $samtools index $chr_bam_file
    } &
    done
    wait
done