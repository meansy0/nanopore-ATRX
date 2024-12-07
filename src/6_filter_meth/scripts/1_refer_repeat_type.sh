#!/bin/bash				
#SBATCH -J 3sam_bed_inter_repeat
#SBATCH -N 4							
#SBATCH -p normal	
#SBATCH -n 24		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err


path=/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data
group_name=s31222_a509_3
data_path=$path/$group_name
refer_repeat_bed=/public/home/xiayini/reference/chm12v2.0/chm13v2.0_RepeatMasker_4.1.2p1.2022Apr14.bed
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
    bed_intersect=chr${chr}_repeat_intersect.bed
    txt_intersect=chr${chr}_repeat_intersect.txt
    bedtools intersect -a chr$chr.bed -b $refer_repeat_bed -wa -wb > $bed_intersect

    sort -k6n,7n $bed_intersect -o $bed_intersect
    total_chr=chr$chr
    awk  -v "chr=$total_chr" '
    {
        key = $6 FS $7 FS $8 FS $11 FS $12;  # 创建一个包含第6、7、8、9列的键
        sum[key] += $4;             # 累加第4列的值
    }
    END {
        for (k in sum) {
            print chr,k,sum[k];  # 打印键和对应的累加结果
        }
    }' $bed_intersect | tr ' ' '\t' > $txt_intersect
    rm $bed_intersect


done




