#!/bin/bash	
#SBATCH -J 1_txt_bed
#SBATCH -N 4							
#SBATCH -p normal	
#SBATCH -n 12		
#SBATCH --mem 300g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err



# example:
    # txt:chr1 1
    # bed:chr1 0 1
convert_to_bed() {
    # Check if input and output file names are provided
    if [ "$#" -ne 2 ]; then
        echo "Usage: $0 input.txt output.bed"
        exit 1
    fi
    input_file=$1
    output_file=$2

    # Process the file
    while IFS= read -r line; do
        # Splitting the line into an array
        read -ra ADDR <<< "$line"

        # Check if we have at least two fields (chromosome and position)
        if [ ${#ADDR[@]} -lt 2 ]; then
            continue
        fi

        # Extract chromosome and position
        chrom=${ADDR[0]}
        pos=${ADDR[1]}

        # Adjust position for BED format (0-based start position)
        let start_pos=$pos-1

        # Create the BED formatted line
        echo -e "$chrom\t$start_pos\t$pos" >> "$output_file"
    done < "$input_file"

    echo "Conversion complete. Output saved to $output_file"
}

/public/home/xiayini/anaconda3/envs/sCell/bin/python /public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/scripts/join_comp/classify.py

path=/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter2Reads
group_name=s31222_a509
number=0
methylation_rate=$(echo "$number == 0.5" | bc)
for i in {1..24}
# for i in  1
do
if [ $i -eq 23 ];then
    chr=X
elif [ $i -eq 24 ];then
    chr=Y
else
    chr=$i
fi
if [ $methylation_rate -eq 0 ];then
    txt_file=${path}/${group_name}/three_locations/chr${chr}.modifis_disappear.txt
    bedfile=${path}/${group_name}/three_locations/chr${chr}.modifis_disappear.bed
else
    txt_file=${path}/${group_name}/three_locations/chr${chr}.${number}.modifis_disappear.txt
    bedfile=${path}/${group_name}/three_locations/chr${chr}.${number}.modifis_disappear.bed
fi

if [ -f "$bedfile" ]; then
    echo "bed file exists."
else
    convert_to_bed $txt_file $bedfile
fi


if [ $methylation_rate -eq 0 ];then
    txt_file=${path}/${group_name}/three_locations/chr${chr}.modifis_grow.txt
    bedfile=${path}/${group_name}/three_locations/chr${chr}.modifis_grow.bed
else
    txt_file=${path}/${group_name}/three_locations/chr${chr}.${number}.modifis_grow.txt
    bedfile=${path}/${group_name}/three_locations/chr${chr}.${number}.modifis_grow.bed
fi


if [ -f "$bedfile" ]; then
    echo "bed file exists."
else
    convert_to_bed $txt_file $bedfile
fi
done
