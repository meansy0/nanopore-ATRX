#!/bin/bash				
#SBATCH -J prepare_summary
#SBATCH -N 1							
#SBATCH -p normal		
#SBATCH --mem 256g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err

samtools=/public/home/xiayini/software/samtools/samtools-1.17/samtools

sample_list=("s31222" "a509" "a509_2" "a509_3")

for sample_id in "${sample_list[@]}";do
    proj_path=/public/home/xiayini/project/nanopore_ATRX
    cd $proj_path
    in_bam_path=1_upstream_analysis/results/${sample_id}/merge.sorted.bam
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
        chr_bam_file=2_vcfV2_analysis/data/${sample_id}/chr${chr_num}.bam
        cat $in_summary_path | cut -f 2 | grep 0 | grep chr${chr_num}  > $out_filter_path
        $samtools view -b $in_bam_path chr${chr_num} > $chr_bam_file
    } &

    # 当已启动五个后，等待它们完成
    if ((chr % 5 == 0)); then
        wait
    fi
    done
    # 确保等待所有剩余的任务完成
    wait
        
    
done

# /public/home/xiayini/anaconda3/envs/cuteSV/bin/python /public/home/xiayini/project/nanopore_ATRX/2_vcfV2_analysis/scripts/filter.py

#     in_bam_path=1_upstream_analysis/results/${sample_id}/merge.sorted.bam
#     out_bam_path=2_vcfV2_analysis/data/${sample_id}/filter.bam
#     cache_bam_header=2_vcfV2_analysis/data/${sample_id}/header.bam
#     # module load apps/samtools/1.16.1-gnu485
#     # samtools view -b -L $out_filter_path $in_sam_path > $out_sam_path
#     # grep -F -w -f $out_filter_path $in_bam_path | $samtools view -b -o $out_bam_path
#     # $samtools view -H $in_bam_path > $cache_bam_header
#     # grep -F -w -f $out_filter_path $in_bam_path | cat $cache_bam_header - | $samtools view -b -o $out_bam_path
#     # rm $cache_bam_header

#     # bedtools intersect -abam input.bam -b reads.bed -u > filtered.bam

# # samtools view -b -L reads.txt
#     # grep -wFf $out_filter_path $in_sam_path | $samtools view -b - > $out_sam_path
#     # $samtools index $out_sam_path
# done

