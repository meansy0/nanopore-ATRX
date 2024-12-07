


type_list=( "DEL" "DUP" "INS" "INV" )

sample_list=( "s31222_a509" "s31222_a509_2" "s31222_a509_3" )
for sample in "${sample_list[@]}";do
    path=/public/home/xiayini/project/nanopore_ATRX/2_vcfV3_analysis/data/joint_multi/difference_$sample
    cat $path/D*.1.read.final.bed $path/I*.1.read.final.bed |awk '{print "An"NR"\t"$0}' >$path/fig1C.bed
done