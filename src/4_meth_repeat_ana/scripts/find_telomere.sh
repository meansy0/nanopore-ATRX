#!/bin/bash				
#SBATCH -J computelo_0_1		
#SBATCH -N 2						
#SBATCH -p normal	
#SBATCH -n 12		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err



cen_bed=/public/home/xiayini/reference/chm12v2.0/chm13v2.0_telomere.bed
supported_reads_list=( "2" "4" "5" )
sample=s31222_a509_a509_2
for supported_read in "${supported_reads_list[@]}";do

    in_folder=/public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/results/filter${supported_read}Reads/
    

    for ((chr=1; chr<=23; chr++));do
        {
        if [ $chr -eq 23 ];then
            chr_name=X
        else
            chr_name=$chr
        fi
        input_txt=${in_folder}${sample}/three_locations/chr${chr_name}.filter.txt
        # input_txt=/public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/results/s31222/chr1.txt
        for ((time=1; time<=2; time++));do
            if [ $time -eq 1 ];then
                line=$((chr * 2 - 1))
            else
                line=$((chr * 2))
            fi
            # echo "$line"
            start=$(head -n ${line} $cen_bed | tail -n1  | cut -f 2)
            # echo "$start"
            end=$(head -n ${line} $cen_bed | tail -n1 | cut -f 3)
            area_len0=$(($end-$start))
            area_len=$(($area_len+$area_len0))
            # echo "$end"
            if [ -f $input_txt ];then
                telomere_part_count=$(awk -v value1="$start" -v value2="$end" '
                    {
                        if($2>=value1 && $2<=value2) print $0
                        }
                ' "$input_txt" | wc -l )
                start=0
                end=0
                
                # echo "$telomere_part_count" 
                
                if [ "$time" -eq 1 ];then
                    telomere_part1_count=$telomere_part_count
                    all_count=$(wc -l < "$input_txt" )

                else
                    telomere_part2_count=$telomere_part_count
                
                fi

                

            fi

        done
        if [ -f $input_txt ];then
            telomere_count=$(($telomere_part1_count + $telomere_part2_count))
            # coverage_rate=$(expr $telomere_count / $all_count)
            # echo "$telomere_count"
            # echo "$all_count"
            
            coverage_rate=$(echo "scale=30; $telomere_count / $area_len" | bc)
            area_len=0

            echo "$coverage_rate"  
            echo "chr$chr_name-------telomere_count:$telomere_count coverage_rate:$coverage_rate"
            telomere_count=0
            all_count=0   
            telomere_part1_count=0
            telomere_part2_count=0
            
            coverage_rate=0  
        fi 


        } &
    done
    wait
done