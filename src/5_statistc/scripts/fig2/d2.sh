
#  基因组注释：甲基化分布的区域

save_path=/public/home/xiayini/project/nanopore_ATRX/5_statistc/data/s31222_a509_2/fig2/d/annotation
cd $save_path


for i in {1..24};do
    if [ $i -eq 23 ];then
        chr=X
    elif [ $i -eq 24 ];then
        chr=Y
    else
        chr=$i
    fi

    # bedtools intersect -a /public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data/s31222_a509_2/chr${chr}.bed -b /public/home/xiayini/reference/chm12v2.0/chm13v2.0_RepeatMasker_4.1.2p1.2022Apr14.bed -wa -wb | 
    # awk '
    # {
    #     key = $5" "$6" "$7
    #     sum[key] += $4
    #     type1[key]=$8
    #     strain[key]=$10
    #     type2[key]=$11
    #     type3[key]=$12
    # }
    # END {
    #     for (k in sum) {
    #     {}  print k, sum[k],type1[k],strain[k],type2[k],type3[k]
    #     }
    # }'|tr ' ' '\t' > chr${chr}.ano.bed

    
done