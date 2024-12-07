

type_list=( "DEL" "DUP" "INS" "INV" )

for svtype in "${type_list[@]}";do
    bed_file=/public/home/xiayini/project/nanopore_ATRX/2_vcfV3_analysis/data/joint_multi/difference_s31222_a509_2/${svtype}.1.read.final.bed 

    bedtools intersect -a $bed_file -b /public/home/xiayini/reference/chm12v2.0/chm13v2.0_censat_v2.0.bed | wc -l 
done

