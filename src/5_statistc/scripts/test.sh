# for sample in "${sample_list[@]}";do
#     sample_str=${sample_str}_${sample}
# done

sample_list=s31222_a509_2_a509_3
sv_list=( "BND" "DEL" "DUP" "INS" "INV")
father_path=/public/home/xiayini/project/nanopore_ATRX
out_path=$father_path/5_combine_meh_sv_analysis/data/$sample_list
if  [ ! -d $out_path ];then
    mkdir -p $out_path
fi


sv_path=$father_path/2_vcfV2_analysis/data/joint_multi/difference_$sample_list
meth_path=$father_path/3_methylation_analysis/results/filter2Reads/$sample_list
sv_bedfile_path=$sv_path/DEL.1.read.final.bed
meth_bedfile_path=$meth_path/three_locations/chr*.modifis_disappear.bed
allmeth_counts=$(wc -l $meth_bedfile_path)
bedtools intersect -a $sv_bedfile_path -b $meth_bedfile_path > $out_path/DEL.1.meth.bed
# echo "$sample_list:all meth counts=$allmeth_counts and metion counts=$counts"