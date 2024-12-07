
name=s31222_a509_2_a509_3
bedtools intersect -a /public/home/xiayini/project/nanopore_ATRX/merge_SV/data/joint_multi_supReads2/difference_${name}/cutesv.filter.1.read.vcf -b /public/home/xiayini/reference/chm12v2.0/chm13v2.0_RepeatMasker_4.1.2p1.2022Apr14.bed -wb | cut -f10- | sort | uniq |
 awk '{
            key = $8 "\t" $9 "\t" $5;
            count[key]++; 
            } END {
                for (k in count) {
                    print k, count[k];  # 打印每个类别的键和对应的计数
                }
            }' |sort -k1

# sam_name_list=("a509" "s31222" "a509_2" "a509_3")

# for single_name in "${sam_name_list[@]}";do          
# grep Simple_repeat /public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/${single_name}/repeat_meth/Chromsome.repeate.methRate.bed > /public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/${single_name}/repeat_meth/Chromsome.repeate.Simple_repeat.methRate.bed
# done