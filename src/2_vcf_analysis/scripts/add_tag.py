import pysam
import sys
import os
def add_tag_to_read_id(input_bam_filename, output_bam_filename, tag):
    # Open the input BAM file for reading
    input_bam = pysam.AlignmentFile(input_bam_filename, "rb")

    # Create a new output BAM file for writing with modified read IDs
    output_bam = pysam.AlignmentFile(output_bam_filename, "wb", header=input_bam.header)

    # Loop through each read in the input BAM file
    for read in input_bam:
        # Modify the read ID to add the desired tag
        read.query_name += tag
        # Write the modified read to the output BAM file
        output_bam.write(read)

    # Close the input and output BAM files
    input_bam.close()
    output_bam.close()

# Example usage
sample_id='a509_3'
print(sample_id)


path="/public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis/data"
input_bam_file = path+"/"+sample_id+"/merge.sorted.bam"
output_bam_file = path+"/"+sample_id+"/merge.sorted.tag.bam"
tag = "_"+sample_id

add_tag_to_read_id(input_bam_file, output_bam_file, tag)
