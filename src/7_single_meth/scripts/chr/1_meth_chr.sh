

sam_name_list=("a509" "s31222" "a509_2" "a509_3")
for sam_name in "${sam_name_list[@]}";do

    path=/public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/$sam_name/create_data
    cd $path
    > ../chr_meth.txt
    for i in {1..24};do
        if [ $i -eq 23 ];then
            chr=X
        elif [ $i -eq 24 ];then
            chr=Y
        else
            chr=$i
        fi

        sum=$(awk '{sum+=$4} END{printf "%.0f\n", sum}' chr$chr.meth.bed)
        # echo $sum
        cg_bed_file=/public/home/xiayini/reference/chm12v2.0/cg_chr/chr$chr.c.g.bed
        cg_sum=$(wc -l < $cg_bed_file)
        # echo "$cg_sum"
        ratio=$(echo "scale=4; $sum / $cg_sum" | bc -l)

        echo -e "chr${chr}\t${ratio}" >> ../chr_meth.txt

    done

done
