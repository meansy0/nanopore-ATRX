#!/bin/bash				
#SBATCH -J fig2d-sam3-data
#SBATCH -N 2						
#SBATCH -p normal		
#SBATCH --mem 100g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err

# Rscript /public/home/xiayini/project/nanopore_ATRX/5_statistc/scripts/fig2/d_data.r

/public/home/xiayini/anaconda3/bin/python /public/home/xiayini/project/nanopore_ATRX/5_statistc/scripts/fig2/d_data.py