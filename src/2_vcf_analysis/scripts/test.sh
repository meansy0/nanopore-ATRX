#!/bin/bash	
#SBATCH -J test		
#SBATCH -N 1							
#SBATCH -p normal		
#SBATCH --mem 128g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err

sample_list=( "a509" "a509_2" )

for sample in "${sample_list[@]}";do
    sample_str=${sample_str}_${sample}
    echo "$sample"

done

sendemail=/public/home/xiayini/software/sendemail/sendEmail

# echo "Job has completed" | $sendemail -m "Job Completed" -f 2292530253@qq.com -t qinixia77@gmail.com