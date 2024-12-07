#!/bin/bash				
#SBATCH -J d2_py_2sam
#SBATCH -N 4							
#SBATCH -p normal	
#SBATCH -n 30		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err

/public/home/xiayini/anaconda3/envs/sCell/bin/python /public/home/xiayini/project/nanopore_ATRX/5_statistc/scripts/fig2/d2.py