#!/bin/bash				
#SBATCH -J rich-3sam		
#SBATCH -N 8							
#SBATCH -p normal	
#SBATCH -n 32		
#SBATCH --mem 200g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err


/public/home/xiayini/anaconda3/envs/pytorch/bin/python3 /public/home/xiayini/project/nanopore_ATRX/6_filter_meth/scripts/meth_rich_window.py