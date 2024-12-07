#!/bin/bash				
#SBATCH -J sniffle_difference1_a509_a509_2	
#SBATCH -N 1							
#SBATCH -p normal		
#SBATCH --mem 128g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err

# sample_list=( "a509" "s31222" )
# sample_list=( "s31222" "a509" "a509_2")
# sample_list=( "s31222" "a509_2" "a509_3")


# readme:
    # need to change "sample_list" in sniffle_final.sh
sample_list=( "s31222" "a509" "a509_2" )

for sample in "${sample_list[@]}";do
    sample_py_list+=" "$sample
done


# 使用参数替换删除首尾空格
trimmed_string="${sample_py_list#"${sample_py_list%%[![:space:]]*}"}"
trimmed_string="${sample_py_list%"${sample_py_list##*[![:space:]]}"}"
bash /public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis/scripts/sniffle_final.sh
# echo "$trimmed_string"
/public/home/xiayini/anaconda3/envs/pytorch/bin/python \
/public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis/scripts/vcf_deal.py "$trimmed_string"