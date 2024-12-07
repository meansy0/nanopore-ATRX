#!/bin/bash				

function classificationFun(){
    sample_list=$1
    trf_bed=/public/home/xiayini/reference/human_GRCh38_no_alt_analysis_set.trf.bed

    # change
    analysis_version=2_vcfV3_analysis

    sample_str=""
    for sample in "${sample_list[@]}";do
        sample_str=${sample_str}_${sample}
    done

    path=/public/home/xiayini/project/nanopore_ATRX/${analysis_version}/data/joint_multi/difference$sample_str
    cd $path
    for num in 1 2; do
        vcf_file=cutesv.filter.$num.read.vcf
        if [ -e "$vcf_file" ];then
            
            cache_bed_file=cutesv.filter.$num.read.bed
            bcftools query -f '%CHROM\t%POS\t%INFO/SVLEN\t%INFO/SVTYPE\n' $vcf_file > $cache_bed_file

            echo "$num"| awk -v num="$num" '{ print > $4 "." num ".read.bed" }' $cache_bed_file

            svtype_list=( "DEL" "DUP" "INS" "INV" "TRA" "BND")
            for sample in "${svtype_list[@]}";do
                bed_file=$sample.$num.read.bed
                final_file=$sample.$num.read.final.bed
                sample_trf_bed_file=$sample.$num.read.trf.bed
                if [ -e "$bed_file" ]; then
                    if [ "$sample" = "DEL" ]; then
                        awk '{$3 = $2 - $3;$2 = $2 - 1; print}' $bed_file |tr ' ' '\t'> $final_file
                        bedtools intersect -a $final_file -b $trf_bed -wa | uniq > $sample_trf_bed_file
                    else
                        awk '{$3 = $2 + $3;$2 = $2 - 1; print}' $bed_file |tr ' ' '\t'> $final_file
                        bedtools intersect -a $final_file -b $trf_bed -wa | uniq > $sample_trf_bed_file
                    fi
                    rm $bed_file
                fi
            done
        fi
    done
}



# # change
sample_list=("a509" "s31222")
classificationFun $sample_list
# sample_list=( "s31222" "a509")
# classificationFun $sample_list

# sample_list=( "s31222" "a509_2" )
# classificationFun $sample_list

# sample_list=( "s31222" "a509_3" )
# classificationFun $sample_list

