



for i in {1..24};do
    if [ $i -eq 23 ];then
        chr=X
    elif [ $i -eq 24 ];then
        chr=Y
    else
        chr=$i
    fi

    site=$(bedtools intersect -a /public/home/xiayini/project/nanopore_ATRX/0_add_ATAC/data/7_4.merge.bed -b /public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data/s31222_a509_2/chr$chr.bed -wb | sort | uniq | awk '{sum+=$7} END{print sum}')
    cg=$(bedtools intersect -a /public/home/xiayini/project/nanopore_ATRX/0_add_ATAC/data/7_4.merge.bed -b /public/home/xiayini/reference/chm12v2.0/cg_chr/chr$chr.c.g.bed  -wb |sort|uniq | wc -l)
   
    result=$(echo "scale=4; $site / $cg" | bc)
    formatted_result=$(printf "%.4f" $result)
    echo "chr$chr:$formatted_result"
done