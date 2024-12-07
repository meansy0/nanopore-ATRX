#!/bin/bash				
#SBATCH -J joinMeth_chr
#SBATCH -N 4							
#SBATCH -p normal	
#SBATCH -n 12		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err

# /public/home/xiayini/anaconda3/envs/sCell/bin/python /public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/scripts/join_comp/1_multi_sample_comp_err.py

# /public/home/xiayini/anaconda3/envs/sCell/bin/python /public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/scripts/join_comp/1_mu_sam_com.py
# /public/home/xiayini/anaconda3/envs/sCell/bin/python /public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/scripts/join_comp/1_multi_sample_comp_chr.py

/public/home/xiayini/anaconda3/envs/sCell/bin/python /public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/scripts/join_comp/1_multi_sample_comp_chr_left.py