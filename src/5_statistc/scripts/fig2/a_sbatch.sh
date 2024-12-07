#!/bin/bash				
#SBATCH -J fig2a-R
#SBATCH -N 4							
#SBATCH -p normal	
#SBATCH -n 24		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err

Rscript /public/home/xiayini/project/nanopore_ATRX/5_statistc/scripts/fig2/a.r