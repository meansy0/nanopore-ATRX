#!/bin/bash				
#SBATCH -J data_2
#SBATCH -N 4							
#SBATCH -p normal	
#SBATCH -n 24		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err


group_name=a509_2


for sv_type in {"DEL","INS"};do
    in_bed_path=/public/home/xiayini/project/nanopore_ATRX/5_statistc/data/s31222_${group_name}/fig3/0_extend_bp/${sv_type}_newData/newData.sv.extend.bed

    save_path=/public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/$group_name/sv_meth

    mkdir -p $save_path
    cd $save_path

    awk '{print $1,$2-500,$2}' $in_bed_path | tr ' ' '\t'  >$sv_type.up.bed
    awk '{print $1,$3,$3+500}' $in_bed_path | tr ' ' '\t'  >$sv_type.down.bed


    for line in {"up","down"};do
        > $sv_type.cg.$line.bed
        # 逐行处理file1文件
        while IFS=$'\t' read -r a b c; do
            # echo "Processing $a $b $c"
            # 在每次循环中，将a、b和c的值读入变量，并处理file2文件
            cg=$(awk -v chr="$a" -v start="$b" -v end="$c" '$2 >= start && $2 <= end {count++} END {print count}' "/public/home/xiayini/reference/chm12v2.0/cg_chr/$a.c.g.bed" | tr ' ' '\t')
            
            meth=$(awk -v chr="$a" -v start="$b" -v end="$c" '$2 >= start && $2 <= end {meth+=$4} END {print meth}' "../create_data/$a.meth.bed" )
            
            ratio=$(echo "scale=4; $meth / $cg" | bc -l)

            echo -e "$a\t$b\t$c\t$ratio" >>$sv_type.cg.$line.bed

        done < $sv_type.$line.bed
        awk 'NF==3{$(NF+1)="0"}1' OFS="\t" $sv_type.cg.$line.bed |awk '{ sub(/\.0/, "0.0", $4) }1' OFS="\t" >$sv_type.methRate.$line.bed
        rm $sv_type.cg.$line.bed
        rm $sv_type.$line.bed
    done

done