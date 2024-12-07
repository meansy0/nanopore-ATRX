#!/bin/bash				
#SBATCH -J base_s31222		
#SBATCH -N 1							
#SBATCH -p gpu		
#SBATCH --mem 128g
#SBATCH --gres=gpu:3
#SBATCH -o %x_%j.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x_%j.err						## 作业stderr 输出文件为: 作业名_作业id.err

# need change line 20(sample_id) to run this script

config=/public/home/xiayini/software/opt/ont/guppy/data/dna_r9.4.1_450bps_modbases_dam-dcm-cpg_hac.cfg
model=/public/home/xiayini/software/opt/ont/guppy/data/template_r9.4.1_450bps_modbases_dam-dcm-cpg_hac.jsn
guppy=/public/home/xiayini/software/guppy-gpu_6.5.7.sif
guppy_cpu=/public/home/xiayini/software/guppy-cpu_6.0.1.sif

genome=/public/home/xiayini/reference/chm13v2.0.name.fa
fa_path=/public/home/xiayini/project/nanopore_ATRX/1_upstream_analysis

sampl_id=s31222

input_files=$fa_path/data/$sampl_id/
output_path=$fa_path/results/$sampl_id/

# 判断目标文件夹是否存在
if [ ! -d "$output_path" ]; then
# 如果文件夹不存在，则创建它
    mkdir -p "$output_path"
fi

module purge
module load apps/singularity/3.8.7
# singularity pull docker://aryeelab/guppy-gpu

# # step1: guppy-basecall(gpu)
singularity exec --nv $guppy guppy_basecaller  \
--input_path $input_files --save_path $output_path --align_ref $genome \
--align_type auto --bam_out --config $config --model_file $model --device cuda:0 --disable_qscore_filtering


#  需要最新版本的samtools
samtools=/public/home/xiayini/software/samtools/samtools-1.17/samtools
path=$output_path

# # 删除无需使用的fastq等文件
rm $path/fastq_runid*.fastq
rm $path/guppy_basecaller_log*.log
rm $path/sequencing_telemetry.js


# step1: samtools-sort
$samtools merge $path/merge.bam $path/bam_runid*.bam
$samtools sort -o $path/merge.sorted.bam $path/merge.bam
$samtools index $path/merge.sorted.bam
# rm $path/bam_runid*.bam
rm $path/merge.bam


# # cpu版
# singularity exec --nv $guppy_cpu guppy_basecaller  \
# --input_path $input_files --save_path $output_path --align_ref $genome \
# --align_type auto --bam_out --config $config --model_file $model --disable_qscore_filtering


# # 后续处理
# cd $output_path
# rm fastq_runid*.fastq
# rm guppy_basecaller_log*.log
# rm sequencing_telemetry.js

# # samtools
