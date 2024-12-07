#!/bin/bash				
#SBATCH -J cuteSV_reads1
#SBATCH -N 4							
#SBATCH -p normal		
#SBATCH --mem 256g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err

function cutesv_fun(){
    fasta_file=/public/home/xiayini/reference/chm13v2.0.name.fa
    sup_reads=$1
    path=$2
    sample_list=("${@:3}") 
    sample_str=""

    for sample in "${sample_list[@]}";do
        sample_str=${sample_str}_${sample}
    done

    if [ $sup_reads -eq 1 ];then
        inpath=$path/data/joint_multi/difference$sample_str
    else
        inpath=$path/data/joint_multi_supReads2/difference$sample_str
    fi
    
    bam_path=$path/data/joint_multi_supReads2/difference$sample_str

    if [ -d $inpath ];then
        echo "inpath exsits!"
    else
        mkdir -p $inpath
        ln -s $bam_path/all.merge.bam $inpath
        ln -s $bam_path/all.merge.bam.bai $inpath
    fi

    cuteSV -t 40 --min_size 50 --max_size 50000000 -S res --report_readid --min_support $sup_reads \
    --genotype --max_cluster_bias_INS 100 --diff_ratio_merging_INS 0.3 --max_cluster_bias_DEL 100 \
    --diff_ratio_merging_DEL 0.3 -q 20 ${inpath}/all.merge.bam $fasta_file \
    ${inpath}/cutesv.vcf --retain_work_dir $inpath

    rm -r $inpath/signatures
    rm $inpath/*.sigs
}


sup_reads=1
path=/public/home/xiayini/project/nanopore_ATRX/2_vcfV2_analysis

# 定义多个样本列表
sample_list1=("a509" "s31222")
echo "${sample_list1[@]}"
sample_list2=("s31222" "a509_2" "a509_3")
sample_list3=("s31222" "a509" "a509_2")


cutesv_fun $sup_reads $path "${sample_list1[@]}"

cutesv_fun $sup_reads $path "${sample_list2[@]}"

cutesv_fun $sup_reads $path "${sample_list3[@]}"
