#!/bin/bash				
#SBATCH -J pileup_a509_2			
#SBATCH -N 1							
#SBATCH -p normal		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err


# Replace "path/to/directory" with the actual path to the directory containing the .fa files


sample_id=a509_2
inpath=/public/home/xiayini/project/nanopore_ATRX/1_upstream_analysis/results/$sample_id
outpath=/public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/data/$sample_id

samtools=/public/home/xiayini/software/samtools/samtools-1.17/samtools

bam_file=$inpath/merge.sorted.bam
final_pileup_file=$outpath/$sample_id.pileup

cat /dev/null > $final_pileup_file

directory="/public/home/xiayini/reference/chr"


for chr_file in $(ls /public/home/xiayini/reference/chr/*.fa | sort -V); do
    # Extract the chromosome name from the file name
    chr_name=$(basename "$chr_file" .fa)
    pileup_file=$outpath/$chr_name.pileup
    echo "$chr_name:start"
    $samtools mpileup $bam_file -f $chr_file --output-mods -o $pileup_file
    cat $pileup_file >> $final_pileup_file
done

rm $outpath/chr*.pileup

# sort -k1,1n $final_pileup_file -o $final_pileup_file
