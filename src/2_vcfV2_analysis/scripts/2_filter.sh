#!/bin/bash				
#SBATCH -J filter_1
#SBATCH -N 1							
#SBATCH -p normal		
#SBATCH --mem 256g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err


/public/home/xiayini/anaconda3/envs/cuteSV/bin/python /public/home/xiayini/project/nanopore_ATRX/2_vcfV2_analysis/scripts/2_filter.py