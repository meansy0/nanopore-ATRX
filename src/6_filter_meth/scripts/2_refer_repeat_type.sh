#!/bin/bash				
#SBATCH -J 1sam_bed_meth_2
#SBATCH -N 4							
#SBATCH -p normal	
#SBATCH -n 24		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err

path=/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data
group_name=s31222_a509
data_path=$path/$group_name
refer_repeat_bed=/public/home/xiayini/reference/chm12v2.0/chm13v2.0_RepeatMasker_4.1.2p1.2022Apr14.bed
cd $data_path
> meth/chr_all.txt
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
    
    all_meth=chr${chr}.bed
    cg_bed_file=/public/home/xiayini/reference/chm12v2.0/cg_chr/chr${chr}.c.g.bed

    sum=$(awk '{sum+=$4} END{print sum}' $all_meth)

    cg_sum=$(wc -l < "$cg_bed_file")
    ratio=$(echo "scale=4; $sum / $cg_sum" | bc -l)
    echo -e "chr${chr}\t${ratio}" >> meth/chr_all.txt
    # bedtools intersect -a chr${chr}_repeat_intersect.txt -b $cg_bed_file -c > chr${chr}_repeat_intersect.bed
    # awk '{print $1,$2,$3,$4,$5,$6,$7/$8}' chr${chr}_repeat_intersect.bed | tr ' ' '\t' >chr${chr}_repeat_meth.txt
    # rm chr${chr}_repeat_intersect.txt

done