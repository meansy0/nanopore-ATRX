#!/bin/bash				
#SBATCH -J compuCent_0_1	
#SBATCH -N 2						
#SBATCH -p normal	
#SBATCH -n 12		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err


funCompu(){
    input_txt=$1
    chr_name=$2
    input_type=$3

    cen_bed=/public/home/xiayini/reference/chm12v2.0/chm13v2.0_censat_v2.0.merge.noY.bed
    start=$(awk -v value1="$chr" 'NR==value1 {print $2}' "${cen_bed}")
    end=$(awk -v value1="$chr" 'NR==value1 {print $3}' "${cen_bed}")
    area_len=$(($end-$start))
    echo "$area_len"
    cen_count=$(awk -v value1="$start" -v value2="$end" '
        {
            if($2>=value1 && $2<=value2) print $0
            }
    ' "$input_txt" | wc -l)
    all_count=$(wc -l < "$input_txt" )
    coverage_rate=$(echo "scale=6; $cen_count / $area_len" | bc)
    echo "chr$chr_name-------$input_type coverage_rate:$coverage_rate"

}


supported_reads_list=( "2" "4" "5" )

for supported_read in "${supported_reads_list[@]}";do

    in_folder=/public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/results/filter${supported_read}Reads/
    sample=s31222_a509_a509_2
    echo "supported reads:${supported_read}"
    for ((chr=1; chr<=23; chr++));do
        if [ $chr -eq 23 ];then
            chr_name=X
        else
            chr_name=$chr
        fi

        sample_type=modifis_grow
        input_txt=${in_folder}${sample}/three_locations/chr${chr_name}.${sample_type}.txt
        if [ -f $input_txt ];then
            funCompu $input_txt $chr_name $sample_type
        
        else
            echo "skip--chr$chr_name:$sample_type"
        fi

        sample_type=modifis_disappear
        input_txt=${in_folder}${sample}/three_locations/chr${chr_name}.${sample_type}.txt
        if [ -f $input_txt ];then
            funCompu $input_txt $chr_name $sample_type
        
        else
            echo "skip--chr$chr_name:$sample_type"
        fi
        sample_type=all
        input_txt=${in_folder}${sample}/three_locations/chr${chr_name}.filter.txt
        if [ -f $input_txt ];then
            funCompu $input_txt $chr_name $sample_type
            
        else
            echo "skip--chr$chr_name:$sample_type"
        fi
    done

done
