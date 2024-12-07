#!/bin/bash	
#SBATCH -J 3_filer_txt2bed
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


group_name=s31222_a509_3
in_path=/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter2Reads/${group_name}/three_locations
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
    cd $in_path
    in_file=chr${chr}.filter.txt
    out_file=chr${chr}.filter.bed

    convert_to_bed $in_file $out_file
    echo "finish ${group_name}:chr${chr}"
done