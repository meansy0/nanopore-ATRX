#!/bin/bash				
#SBATCH -J meth_rate
#SBATCH -N 2						
#SBATCH -p normal		
#SBATCH --mem 100g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err



# 计算各个类型上的甲基化程度和总的甲基化程度 
# by chr
computeRate(){
    chr_num=$3
    fa_file=/public/home/xiayini/reference/chr/chr$chr_num.fa
    type_bed_file=$1
    type=${2}_chr
    bed_file=/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter2Reads/s31222_a509/three_locations/chr1.0.5.modifis_grow.bed
    meth_save_num=$(bedtools intersect -a $type_bed_file -b $bed_file -wb | wc -l)

    save_folder=/public/home/xiayini/reference/chm12v2.0/$type
    mkdir -p $save_folder
    save_bed_file=$save_folder/chr${chr_num}.bed
    save_fa_file=$save_folder/chr${chr_num}.fa
    awk -v  chr="chr$chr_num" '{if($1==chr) print $0}' $type_bed_file> $save_bed_file
    bedtools getfasta -fi $fa_file -bed $save_bed_file > $save_fa_file
    save_num=$(grep -v "^>"  $save_fa_file | awk 'BEGIN{FS=""; sum=0} {for(i=1; i<=NF; i++) if($i=="C" || $i=="G"|| $i=="c"|| $i=="g") sum++} END{print sum}')


    meth_total_num=$( wc -l $bed_file| awk '{print $1}')
    len_file=/public/home/xiayini/reference/chm13v2.0.name.len.txt

    total_num=$(grep -v "^>"  $fa_file | awk 'BEGIN{FS=""; sum=0} {for(i=1; i<=NF; i++) if($i=="C" || $i=="G"|| $i=="c"|| $i=="g") sum++} END{print sum}')

    echo "type:$2"
    echo $meth_save_num
    echo $save_num
    echo $meth_total_num
    echo $total_num
    echo "scale=20; $meth_save_num/$save_num" | bc
    echo "scale=20; $meth_total_num/$total_num" | bc
    echo ""



}


chr_num=1


type_bed_file=/public/home/xiayini/reference/chm12v2.0/chm13v2.0_RepeatMasker_4.1.2p1.2022Apr14.bed
type=repeat
computeRate $type_bed_file $type $chr_num

type_bed_file=/public/home/xiayini/reference/chm12v2.0/chm13v2.0_censat_v2.0.merge.noY.bed
type=censat
computeRate $type_bed_file $type $chr_num

type_bed_file=/public/home/xiayini/reference/chm12v2.0/chm13v2.0_telomere.bed
type=telomere
computeRate $type_bed_file $type $chr_num