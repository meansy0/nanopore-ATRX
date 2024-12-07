

sample_list=("s31222_a509" "a509_s31222" "s31222_a509_2" "s31222_a509_3")
sv_type_list=("INS" "DEL")
for sample_id in "${sample_list[@]}";do
    for sv_type in "${sv_type_list[@]}";do
        cd /public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data/$sample_id/sv/$sv_type
        > all_chr_sv.csv
        cat all_chr*_sv_ratios.csv | cut -f 4 | grep -v "un" >>all_chr_sv.csv
    done
done