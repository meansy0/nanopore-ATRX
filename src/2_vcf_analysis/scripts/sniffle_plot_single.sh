#!/bin/bash				
#SBATCH -J snifflePlot_a509			
#SBATCH -N 1							
#SBATCH -p normal		
#SBATCH --mem 128g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err


path=/public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis
sample_id=a509_2

sniffle_plot_path=/public/home/xiayini/software/sniffle2_plot
cd $sniffle_plot_path

# single sample
python sniffles2_plots.py -i  $path/results/$sample_id/sniffle.vcf -o $path/results/$sample_id

