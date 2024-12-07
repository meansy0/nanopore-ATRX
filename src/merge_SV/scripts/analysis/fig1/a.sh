

save_path=/public/home/xiayini/project/nanopore_ATRX/merge_SV/results/analysis/fig1a/total_SV.csv
echo "SampleID,new_total_SV,dis_total_SV" > $save_path
sample_list=( "a509_s31222" "s31222_a509_a509_2" "s31222_a509_2_a509_3" )
for group_name in "${sample_list[@]}";do

    data_path=/public/home/xiayini/project/nanopore_ATRX/merge_SV/data/joint_multi_supReads2/difference_${group_name}
    cd $data_path


    growth=$(wc -l < cutesv.filter.1.read.bed)
    loss=$(wc -l < cutesv.filter.2.read.bed)
    
    echo "$group_name,$growth,$loss" >> $save_path

done