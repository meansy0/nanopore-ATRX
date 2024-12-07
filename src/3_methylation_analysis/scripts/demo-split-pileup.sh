#!/bin/bash				
#SBATCH -J pileup_a509_2			
#SBATCH -N 4							
#SBATCH -p normal	
#SBATCH -n 12		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err

# $1:input_files(the path of bam and other upstreams files)
# eg $1:/public/home/xiayini/project/nanopore_ATRX/1_upstream_analysis/results/a509

sample_id=a509_2

samtools=/public/home/xiayini/software/samtools/samtools-1.17/samtools

refer_fasta_folder=/public/home/xiayini/reference/demo-chr/chr

in_path=/public/home/xiayini/project/nanopore_ATRX/1_upstream_analysis/results
out_path=/public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/data
bam_file=$in_path/$sample_id/merge.sorted.bam

# final_pileup_file=$out_path/$sample_id/$sample_id.pileup
# cat /dev/null > $final_pileup_file

for ((chr=1; chr<=24; chr++)); do
    # {
    if [ $chr -ge 23 ];then
        if [ $chr -eq 23 ];then
            sexy_chr=X
        else
            sexy_chr=Y
        fi
        chr_fasta_file=$refer_fasta_folder/chr${sexy_chr}.fa
        chr_pileup_file=$out_path/$sample_id/chr${sexy_chr}.pileup
        chr_bam_file=$out_path/$sample_id/chr${sexy_chr}.bam
        # $samtools view -b $bam_file chr${sexy_chr} > $chr_bam_file
        if [ -f $chr_bam_file ];then
            $samtools mpileup $chr_bam_file -f $chr_fasta_file --output-mods -o $chr_pileup_file
            echo "start:chr$sexy_chr"
        fi

    else
        chr_fasta_file=$refer_fasta_folder/chr${chr}.fa
        chr_pileup_file=$out_path/$sample_id/chr${chr}.pileup
        chr_bam_file=$out_path/$sample_id/chr${chr}.bam

        # $samtools view -b $bam_file chr${chr} > $chr_bam_file
        if [ -f $chr_bam_file ];then
            $samtools mpileup $chr_bam_file -f $chr_fasta_file --output-mods -o $chr_pileup_file
            echo "start:chr$chr"
        fi        

    fi
    # cat $chr_pileup_file >> $final_pileup_file
    # rm $chr_pileup_file
    
    # } &
done
# wait





