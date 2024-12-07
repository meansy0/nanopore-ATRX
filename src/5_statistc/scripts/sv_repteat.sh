#!/bin/bash				
#SBATCH -J classification
#SBATCH -N 2						
#SBATCH -p normal		
#SBATCH --mem 256g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err


trf_bed=/public/home/xiayini/reference/chm12v2.0/chm13v2.0_RepeatMasker_4.1.2p1.2022Apr14.bed

# change
analysis_version=2_vcfV2_analysis
# sample_list=( "a509" "s31222" )
# sample_list=( "s31222" "a509" "a509_2" )
sample_list=( "s31222" "a509_2" "a509_3" )
sup_reads=1


sample_str=""
for sample in "${sample_list[@]}";do
    sample_str=${sample_str}_${sample}
done

if [ $sup_reads -eq 2 ];then
    path=/public/home/xiayini/project/nanopore_ATRX/${analysis_version}/data/joint_multi_supReads2/difference$sample_str
else
    path=/public/home/xiayini/project/nanopore_ATRX/${analysis_version}/data/joint_multi/difference$sample_str

fi

cd $path

for num in 1 2; do
    vcf_file=cutesv.filter.$num.read.vcf
    if [ -e "$vcf_file" ];then
        
        cache_bed_file=cutesv.filter.$num.read.bed
        bcftools query -f '%CHROM\t%POS\t%INFO/SVLEN\t%INFO/SVTYPE\n' $vcf_file > $cache_bed_file

        echo "$num"| awk -v num="$num" '{ print > $4 "." num ".read.bed" }' $cache_bed_file

        svtype_list=( "DEL" "DUP" "INS" "INV" "TRA" )
        for sample in "${svtype_list[@]}";do
            bed_file=$sample.$num.read.bed
            final_file=$sample.$num.read.final.bed
            sample_repeat_bed_file=$sample.$num.read.repeat.bed
            if [ -e "$bed_file" ]; then
                if [ "$sample" = "DEL" ]; then
                    awk '{$3 = $2 - $3;$2 = $2 - 1; print}' $bed_file |tr ' ' '\t'> $final_file
                    bedtools intersect -a $final_file -b $trf_bed -wa | uniq > $sample_repeat_bed_file
                else
                    awk '{$3 = $2 + $3;$2 = $2 - 1; print}' $bed_file |tr ' ' '\t'> $final_file
                    bedtools intersect -a $final_file -b $trf_bed -wa | uniq > $sample_repeat_bed_file
                fi
                rm $bed_file
            fi
        done
    fi
done


