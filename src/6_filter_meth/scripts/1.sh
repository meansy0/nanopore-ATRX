#!/bin/bash				
#SBATCH -J txt-1sam		
#SBATCH -N 4							
#SBATCH -p normal	
#SBATCH -n 24		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err


path=/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data

group_name=a509_s31222
data_path=$path/$group_name
mkdir -p $data_path
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
    
    txt_path=/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter2Reads/$group_name/three_locations/chr${chr}.filter.txt
    
    save_txt_path=$data_path/chr$chr.txt
    save_bed_path=$data_path/chr$chr.bed
    if [ -e $save_txt_path ];then
        echo "chr${chr} file exists"
        
    else
        awk '{ 
            split($3, array1, ":"); 
            split(array1[2], value1, ","); 
            split($4, array2, ":"); 
            split(array2[2], value2, ","); 
            if ((value1[1] * 1.2) < value2[1]) 
                print $0; 
        }' $txt_path > $save_txt_path

        awk '{print $1,$2-1,$2}' $save_txt_path | tr  ' ' '\t' >$save_bed_path

    fi

done

