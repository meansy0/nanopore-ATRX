#!/bin/bash				
#SBATCH -J index
#SBATCH -N 1							
#SBATCH -p normal		
#SBATCH --mem 256g

sample_list=("s31222" "a509" "a509_2" "a509_3")

for sample_id in "${sample_list[@]}";do
    
    proj_path=/public/home/xiayini/project/nanopore_ATRX
    cd $proj_path   
    in_summary_path=1_upstream_analysis/results/${sample_id}/sequencing_summary.txt
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
        out_filter_path=2_vcfV2_analysis/data/${sample_id}/chr${chr_num}_summary_second_align_filter.txt
        cat $in_summary_path | grep chr${chr_num} | cut -f 2,37 | awk '{if($2==0) print $1}' > $out_filter_path

    } &
    done
    wait


done
