cuteSV -t 40 --min_size 50 --max_size 50000000 -S res --report_readid --min_support 1 \
--genotype --max_cluster_bias_INS 100 --diff_ratio_merging_INS 0.3 \
--max_cluster_bias_DEL 100 --diff_ratio_merging_DEL 0.3 -q 20 \
/public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis/data/joint_multi/merge.sorted.bam \
/public/home/xiayini/reference/chm13v2.0.name.fa \
/public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis/data/joint_multi/cutesv.vcf \
--retain_work_dir /public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis/data/joint_multi