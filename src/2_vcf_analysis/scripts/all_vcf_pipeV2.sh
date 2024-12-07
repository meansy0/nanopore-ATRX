#!/bin/bash				
#SBATCH -J vcfV2_time2
#SBATCH -N 1							
#SBATCH -p normal		
#SBATCH --mem 256g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err

bash /public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis/scripts/1_2cutesv.sh
/public/home/xiayini/anaconda3/bin/python /public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis/scripts/2_vcfV2.py
bash /public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis/scripts/3_bed.sh