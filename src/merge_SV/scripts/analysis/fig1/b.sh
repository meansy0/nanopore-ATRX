
sample_list=( "a509_s31222" "s31222_a509_a509_2" "s31222_a509_2_a509_3" )


# sv_list=( "BND" "DEL" "DUP" "INS" )
for group_name in "${sample_list[@]}";do
    cd /public/home/xiayini/project/nanopore_ATRX/merge_SV/data/joint_multi_supReads2/difference_$group_name
    save_bed=/public/home/xiayini/project/nanopore_ATRX/merge_SV/results/analysis/fig2/b_$group_name.bed

    cat *.1.read.final.bed | awk '{sum++; print sum,$0}'|tr ' '  '\t' > $save_bed
    sort -k3n,3n $save_bed -o $save_bed

done