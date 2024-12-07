


sample_list=( "a509_s31222" "s31222_a509_a509_2" "s31222_a509_2_a509_3" )
for group_name in "${sample_list[@]}";do

    data_path=/public/home/xiayini/project/nanopore_ATRX/merge_SV/data/joint_multi_supReads2/difference_${group_name}
    cd $data_path
    telomere_bed=/public/home/xiayini/reference/chm12v2.0/chm13v2.0_telomere.bed
    bedtools intersect -a cutesv.filter.1.read.vcf -b $telomere_bed >/public/home/xiayini/project/nanopore_ATRX/merge_SV/results/analysis/fig1/e_svI_telomere.${group_name}.bed


done