#!/bin/bash				
#SBATCH -J snifflePlot_jointMulti		
#SBATCH -N 1							
#SBATCH -p normal		
#SBATCH --mem 32g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err

path=/public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis

sample_list=("a509" "a509_2")

data_path=$path/data/joint_multi
results_path=$path/results/joint_multi
if [ ! -d "$data_path" ];then
    mkdir $data_path
    for sample_id in "${sample_list[@]}";do
        ln -s $path/results/$sample_id/${sample_id}_sniffle.vcf $data_path
    done 

fi

sniffle_plot_path=/public/home/xiayini/software/sniffle2_plot
cd $sniffle_plot_path

# multi sample
python sniffles2_plots.py -i $data_path -o $results_path






