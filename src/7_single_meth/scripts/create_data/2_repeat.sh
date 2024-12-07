#!/bin/bash				
#SBATCH -J 2_repeat
#SBATCH -N 4							
#SBATCH -p normal	
#SBATCH -n 24		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err


sam_name_list=("a509" "s31222" "a509_2" "a509_3")

for sam_name in "${sam_name_list[@]}";do

    save_path=/public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/$sam_name/create_data
    cd $save_path

    for i in {20..24};do
        if [ $i -eq 23 ];then
            chr=X
        elif [ $i -eq 24 ];then
            chr=Y
        else
            chr=$i
        fi

        meth_bed=chr$chr.meth.bed
        chr_refer_repeat_bed=/public/home/xiayini/reference/chm12v2.0/repeat_chr/cg/chr$chr.cg.chm13v2.0.bed
        meth_repeat_bed=chr$chr.meth.repeat.bed
        bedtools intersect  -a $chr_refer_repeat_bed -b $meth_bed -wa -wb | cut -f 1-8,11-15 |tr ' ' '\t' > $meth_repeat_bed 

        awk '{
            key = $2 "\t" $3 "\t" $9;
            count[key]+=$13; 
            } END {
                for (k in count) {
                    print k, count[k];  # 打印每个类别的键和对应的计数
                }
            }' $meth_repeat_bed | awk -v "chr=$chr" '{print "chr"chr,$0}'|tr ' ' '\t' > chr$chr.methRate.txt
            
            awk '{
                printf "%s\t%s\t%s\t%.4f\n", $1,$2,$3,$5/$4}' chr$chr.methRate.txt |tr ' ' '\t' >../chr$chr.methRate.bed


    done
done

# name=a509_3
# mkdir -p /public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/$name/create_data/
# cp /public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/$name/*.pileup /public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/$name/create_data/
# rm /public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/$name/*.pileup
# cp /public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/$name/*.bed /public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/$name/create_data/
# rm /public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/$name/*.bed

#  bedtools intersect -a /public/home/xiayini/project/nanopore_ATRX/2_vcfV3_analysis/data/joint_multi/difference_s31222_a509_2/cutesv.filter.1.read.vcf -b /public/home/xiayini/reference/chm12v2.0/chm13v2.0_RepeatMasker_4.1.2p1.2022Apr14.bed -wb|cut -f 14-| sort |uniq| awk '{sum[$4]++} END{for(k in sum) print k,sum[k]}'