#!/bin/bash				
#SBATCH -J pileup_cg				
#SBATCH -N 1							
#SBATCH -p normal		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err

# $1:input_files(the path of bam and other upstreams files)
# eg $1:/public/home/xiayini/project/nanopore_ATRX/1_upstream_analysis/results/a509

samtools=/public/home/xiayini/software/samtools/samtools-1.17/samtools
reference_fa=/public/home/xiayini/reference/chm13v2.0.name.fa
c_bed_file=/public/home/xiayini/reference/chm13v2.0.name.c.merge.bed
path=/public/home/xiayini/project/nanopore_ATRX/1_upstream_analysis/results/a509
bam_file=$path/merge.sorted.bam
# c_pileup_file=$path/merge.mods.c.pileup
pileup_file=$path/merge.sorted.pileup

# g_bed_file=/public/home/xiayini/reference/chm13v2.0.name.g.merge.bed
# g_pileup_file=$path/merge.mods.g.pileup
# $samtools mpileup $bam_file -l $c_bed_file --output-mods -o $c_pileup_file
# $samtools mpileup $bam_file -l $g_bed_file --output-mods -o $g_pileup_file

$samtools mpileup $bam_file -f $reference_fa --output-mods -o $pileup_file


# for chr in {10..22};do

# $samtools mpileup $bam_file -l $c_bed_file --output-mods -o $path/chr${chr}_c.pileup -r chr${chr} --incl-flags [0]
# $samtools mpileup $bam_file -l $g_bed_file --output-mods -o $path/chr${chr}_g.pileup -r chr${chr} --incl-flags [16]

# done

# cat $path/*pileup >> $path/merge.pileup
# rm $path/chr*

