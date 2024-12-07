import pysam
import sys
import os
from multiprocessing import Pool

def process_add_tag_to_read_id(path,chr,sample_id):
    if chr >= 23:
        chr_num = 'X' if chr == 23 else 'Y'
    else:
        chr_num = str(chr)

    tag = "_"+sample_id
    input_bam_filename = f"{path}/{sample_id}/chr{chr_num}.filter.bam"
    output_bam_filename = f"{path}/{sample_id}/chr{chr_num}.filter.tag.bam"

    # Open the input BAM file for reading
    input_bam = pysam.AlignmentFile(input_bam_filename, "rb")

    # Create a new output BAM file for writing with modified read IDs
    output_bam = pysam.AlignmentFile(output_bam_filename, "w", template=input_bam)


    # Loop through each read in the input BAM file
    for read in input_bam:
        print("1")
        # Modify the read ID to add the desired tag
        read.query_name += tag
        # Write the modified read to the output BAM file
        output_bam.write(read)

    # Close the input and output BAM files
    input_bam.close()
    output_bam.close()


if __name__ == "__main__":
    # Example usage
    sample_list=["s31222","a509","a509_2","a509_3"]

    path="/public/home/xiayini/project/nanopore_ATRX/2_vcfV2_analysis/data"
    num_processes=5
    chromosomes=list(range(1,25))
    for sample_id in sample_list:
        with Pool(processes=num_processes) as pool:
            pool.starmap(process_add_tag_to_read_id,[(path,chr,sample_id) for chr in chromosomes])
