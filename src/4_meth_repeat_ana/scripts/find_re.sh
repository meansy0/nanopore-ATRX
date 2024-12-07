#!/bin/bash				
#SBATCH -J compuRepteat				
#SBATCH -N 1						
#SBATCH -p normal	
#SBATCH -n 12		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err



# get bed file
folder_path=/public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/results/s31222_a509_2_a509_3/three_locations


funCompu (){
    input_txt=$3
    out_bed=$4
    awk  '{ print $1 "\t" $2-1 "\t" $2 }' $input_txt > $out_bed 
    sort -k1n $out_bed -o $out_bed
    repeat_count=$(bedtools intersect -a $reference_bed -b $out_bed -wb |wc -l)

    all_count=$(wc -l < $out_bed)
    # all_count=$(wc -l < "$input_txt" )

    # coverage_rate=$(echo "scale=3; $repeat_count / $all_count" | bc)
    coverage_rate=$(awk -v value1=$repeat_count -v value2=$all_count 'BEGIN{printf "%.2f\n", value1/value2 }')
    
    echo "chr$chr_name-------$2:$coverage_rate"


}

# reference repeat file
reference_bed=/public/home/xiayini/reference/chm12v2.0/chm13v2.0_RepeatMasker_4.1.2p1.2022Apr14.bed

for ((chr=1; chr<=24; chr++));do
    {
    if [ $chr -ge 23 ];then
        if [ $chr -eq 23 ];then
            chr_name=X
        else
            chr_name=Y
        fi

    else
        chr_name=$chr
    fi

    
    filter_txt=$folder_path/chr$chr_name.modifis_grow.txt
    if [ -f "$filter_txt" ];then
        filter_txt_out=$folder_path/chr$chr_name.modifis_grow.bed
        
        funCompu $chr_name modifis_grow $filter_txt $filter_txt_out
    else
        echo "skip:modifis_grow"
    fi
    filter_txt=$folder_path/chr$chr_name.modifis_disappear.txt
    if [ -f "$filter_txt" ];then
        filter_txt_out=$folder_path/chr$chr_name.modifis_disappear.bed
        funCompu $chr_name modifis_disappear $filter_txt $filter_txt_out
    else
        echo "skip--chr$chr_name:modifis_disappear"
    fi

    filter_txt=$folder_path/chr$chr_name.filter.txt
    if [ -f "$filter_txt" ];then
        filter_txt_out=$folder_path/chr$chr_name.filter.bed
        funCompu $chr_name all $filter_txt $filter_txt_out
    else
        echo "skip:all"
    fi

    } &
done
wait