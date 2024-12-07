# this is for repeate data in chromsome

sam_name_list=("a509" "s31222" "a509_2" "a509_3")

for name in "${sam_name_list[@]}";do
    for i in {20..24};do
        if [ $i -eq 23 ];then
            chr=X
        elif [ $i -eq 24 ];then
            chr=Y
        else
            chr=$i
        fi
        rate_bed=/public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/$name/chr$chr.methRate.bed
        refer_repeate_bed=/public/home/xiayini/reference/chm12v2.0/repeat_chr/cg/chr$chr.chm13v2.0.bed
        bedtools intersect -a $rate_bed -b $refer_repeate_bed -wb > /public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/$name/chr$chr.repeate.methRate.bed
        rm $rate_bed
    done
done

cat /public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/$name/chr*.repeate.methRate.bed >> /public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/$name/Chromsome.repeate.methRate.bed

mkdir -p /public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/$name/repeat_meth
rm /public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/$name/chr*.bed 
