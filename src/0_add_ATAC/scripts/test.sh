


# cd /public/home/xiayini/project/nanopore_ATRX/0_add_ATAC/2.cleandata/PEPATAC_res
# for in_peak_bed in  {7-sh590-1_FKDL210117401-1a_peaks_coverage.bed,8-sh590-2_FKDL210117402-1a_peaks_coverage.bed,9-sh590-3_FKDL210117403-1a_peaks_coverage.bed};do
#     # in_peak_bed=
#     peak_bed=/public/home/xiayini/project/nanopore_ATRX/0_add_ATAC/data/8.bed

#     for len in {500,1000};do
#         cat $in_peak_bed | awk  -v "sum=$len" '{print $1,$2-sum,$3+sum}' | tr ' ' '\t' | grep -v 'Un' | grep -v 'random'> $peak_bed

#         sv_bed=/public/home/xiayini/project/nanopore_ATRX/2_vcfV3_analysis/data/joint_multi/difference_s31222_a509_3/DEL.1.read.final.bed
#         meth_bed=/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter2Reads/s31222_a509/three_locations/chr1.filter.bed
#         bedtools intersect -a $meth_bed -b $peak_bed |sort |uniq| wc -l 

#     done

# done



in_peak_bed=/public/home/xiayini/project/nanopore_ATRX/0_add_ATAC/data/7_4.merge.bed
peak_bed=/public/home/xiayini/project/nanopore_ATRX/0_add_ATAC/data/7_4.extend.bed
for len in {1};do
    cat $in_peak_bed | awk  -v "sum=$len" '{print $1,$2-sum,$3+sum}' | tr ' ' '\t' | grep -v 'Un' | grep -v 'random'> $peak_bed

    sv_bed=/public/home/xiayini/project/nanopore_ATRX/2_vcfV3_analysis/data/joint_multi/difference_s31222_a509_3/DEL.1.read.final.bed
    meth_bed=/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter2Reads/s31222_a509/three_locations/chr1.filter.bed
    bedtools intersect -a $meth_bed -b $peak_bed |sort |uniq| wc -l 

done


# chr1: 
    # si rate:511.202
    # cg rate:206380