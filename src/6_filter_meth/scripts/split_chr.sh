#!/bin/bash				
#SBATCH -J sam3_splitBed
#SBATCH -N 4							
#SBATCH -p normal	
#SBATCH -n 24		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err



group_name=s31222_a509
data_path=/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data/$group_name/split_bed
mkdir -p $data_path
cd $data_path
for i in {1..24}
# for i in  1
do
    if [ $i -eq 23 ];then
        chr=X
    elif [ $i -eq 24 ];then
        chr=Y
    else
        chr=$i
    fi

    split -n l/5 ../chr$chr.bed -d --additional-suffix=.bed chr${chr}_

done