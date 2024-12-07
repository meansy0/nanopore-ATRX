
#!/bin/bash

sample="a509_2"
samtools="/public/home/xiayini/software/samtools/samtools-1.17/samtools"

# 输入 BAM 文件和输出文件夹
input_bam="/public/home/xiayini/project/nanopore_ATRX/1_upstream_analysis/results/$sample/merge.sorted.bam"
folder="/public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/data"
output_folder="$folder/$sample/bam_split"

# 创建输出文件夹
mkdir -p "$output_folder"
#!/bin/bash

# 输入 BAM 文件和输出文件夹
input_bam="input.bam"
output_folder="output_split_bam"

# 创建输出文件夹
mkdir -p "$output_folder"

# 获取 BAM 文件的大小（以字节为单位）
bam_size=$(stat -c %s "$input_bam")

# 计算每个小文件的大小
split_size=$((bam_size / 10))

# 使用 samtools 进行拆分
samtools view -H "$input_bam" > "$output_folder/header.sam"  # 提取 BAM 头部信息

# 拆分 BAM 文件并命名
start=1
split_idx=1
while [ $start -le $bam_size ]; do
    split_file="$output_folder/split$split_idx.bam"
    $samtools view -b "$input_bam" | tail -c +$start | head -c $split_size > "$split_file"
    start=$((start + split_size))
    split_idx=$((split_idx + 1))
done

# 移除临时头部文件
rm "$output_folder/header.sam"
