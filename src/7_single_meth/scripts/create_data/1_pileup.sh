#!/bin/bash				
#SBATCH -J 1_pileup
#SBATCH -N 4							
#SBATCH -p normal	
#SBATCH -n 24		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err



sam_name_list=("a509" "s31222" "a509_2" "a509_3")
in_path=/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter2Reads
for sam_name in "${sam_name_list[@]}";do

    save_path=/public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/$sam_name
    cd $save_path

    for i in {1..24};do
        if [ $i -eq 23 ];then
            chr=X
        elif [ $i -eq 24 ];then
            chr=Y
        else
            chr=$i
        fi

        grep +m $in_path/${sam_name}/chr${chr}.pileup >chr${chr}.meth.pileup

        awk '{
            m_count = gsub(/\+\m[0-9]+/, "&");  # 计算每行中 "+m" 的数量
            if ($4 != 0) {  # 避免除以零
                sum = m_count / $4;  # 累加每行 "+m" 数量除以第四列的值
                printf "%s\t%s\t%s\t%.4f\n", $1, $2-1,$2, sum; 
            }
        } END {
            
        }' chr${chr}.meth.pileup >chr${chr}.meth.bed

    done

done
