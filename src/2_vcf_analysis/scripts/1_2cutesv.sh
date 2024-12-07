

fa_path=/public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis
fasta_file=/public/home/xiayini/reference/chm13v2.0.name.fa

# change
# sample_list=( "a509" "s31222" )
sample_list=( "s31222" "a509_2" "a509_3" )
sample_str=""
for sample in "${sample_list[@]}";do
    sample_str=${sample_str}_${sample}
done


inpath=$fa_path/data/joint_multi_supReads2/difference$sample_str
bam_path=$fa_path/data/joint_multi/difference$sample_str
if [ -d $inpath ];then
    echo "inpath exsits!"
else
    mkdir $inpath
    ln -s $bam_path/merge.sorted.bam $inpath
    ln -s $bam_path/merge.sorted.bam.bai $inpath
fi

cuteSV -t 40 --min_size 50 --max_size 50000000 -S res --report_readid --min_support 2 \
--genotype --max_cluster_bias_INS 100 --diff_ratio_merging_INS 0.3 --max_cluster_bias_DEL 100 \
--diff_ratio_merging_DEL 0.3 -q 20 ${inpath}/merge.sorted.bam $fasta_file \
${inpath}/cutesv.vcf --retain_work_dir $inpath

rm -r $inpath/signatures
rm $inpath/*.sigs