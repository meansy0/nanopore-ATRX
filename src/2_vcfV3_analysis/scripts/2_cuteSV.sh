#!/bin/bash				
#SBATCH -J cuteSV	
#SBATCH -N 2			
#SBATCH -n 48					
#SBATCH -p normal		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err


function cutesvDeal(){
    fa_path=/public/home/xiayini/project/nanopore_ATRX/2_vcfV3_analysis
    fasta_file=/public/home/xiayini/reference/chm13v2.0.name.fa

    sample_list=$1
    sample_str=""
    for sample in "${sample_list[@]}";do
        sample_str=${sample_str}_${sample}
    done

    inpath=$fa_path/data/joint_multi/difference$sample_str
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

}



# change
sample_list=( "s31222" "a509")
cutesvDeal $sample_list

sample_list=( "s31222" "a509_2" )
cutesvDeal $sample_list

sample_list=( "s31222" "a509_3" )
cutesvDeal $sample_list

