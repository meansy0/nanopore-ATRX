group_name=s31222_a509_3
in_path=/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter2Reads/${group_name}/three_locations
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
    cd $in_path
    in_file=chr${chr}.filter.txt
    out_file=chr${chr}.filter.bed

    convert_to_bed $in_file $out_file
    echo "finish ${group_name}:chr${chr}"
done