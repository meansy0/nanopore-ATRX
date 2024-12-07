#!/bin/bash				
#SBATCH -J 1_filterpileup	
#SBATCH -N 4							
#SBATCH -p normal	
#SBATCH -n 12		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err


# --dependency=afterok:137815
# 输入参数support_reads & rate
supported_reads_list=( "2" "4" "5" )
rate=0.5
sample_list=( "a509_3")

for supported_reads in "${supported_reads_list[@]}";do
    
    for sample_id in "${sample_list[@]}";do

        echo "this is sample $sample_id"
        if [ $supported_reads -eq 2 ];then
            in_path=/public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/data/$sample_id
        else
            in_path=/public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/results/filter2Reads/$sample_id
        fi

        out_path=/public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/results/filter${supported_reads}Reads/$sample_id

        if [ ! -d $out_path ];then
            mkdir $out_path
        fi

        for ((chr=1; chr<=24; chr++)); do
            {
            if [ $chr -ge 23 ];then
                if [ $chr -eq 23 ];then
                    new_chr=X
                else
                    new_chr=Y
                fi

            else
                new_chr=$chr
            fi

            in_pile_file=$in_path/chr${new_chr}.pileup

            out_pile_file=$out_path/chr${new_chr}.pileup
            if [ -f $in_pile_file ];then
                # awk -v value="$supported_reads" -v sid="$sample_id" '
                #     $4 >= value {
                #         print $0, sid
                #     }
                #     ' "$in_pile_file" | tr ' ' '\t' > "$out_pile_file"

                awk -v value="$supported_reads" -v sid="$sample_id" '
                    $4 >= value {
                        if ($3 == "c" || $3 == "C" || $3 == "g" || $3 == "G") {
                            print $0, sid
                        }
                    }
                    ' "$in_pile_file" | tr ' ' '\t' > "$out_pile_file"
            else
                echo "chr"$new_chr" not exsit,skip!"
            fi
            } &
        done
        wait
    done

done