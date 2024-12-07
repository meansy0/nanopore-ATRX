#!/bin/bash				
#SBATCH -J rich-1sam		
#SBATCH -N 8							
#SBATCH -p normal	
#SBATCH -n 32		
#SBATCH --mem 200g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err



#!/bin/bash



# 设置窗口大小和步长
window_size=4000
step_size=8000
group_num=s31222_a509

# 设置染色体长度文件的路径
chr_len_file="/public/home/xiayini/reference/chm13v2.0.name.len.txt"
# 声明关联数组来存储染色体长度
declare -A chr_len_dict

# 读取染色体长度文件
while IFS=$'\t' read -r chr other len
do
    # 提取长度并去除可能的换行符
    len=$(echo "$len" | tr -d '\n')
    
    # 存储到关联数组中
    chr_len_dict[$chr]=$len
done < "$chr_len_file"


sample_path=/public/home/xiayini/project/nanopore_ATRX/6_filter_meth

cd $sample_path

in_path=data/${group_num}
save_path=results/${group_num}

# 使用数组来存储结果
declare -a results


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
    

    max_length=${chr_len_dict["chr$chr"]}
    cg_bed_file=/public/home/xiayini/reference/chm12v2.0/cg_chr/chr${chr}.c.g.bed

    sample_bed_file=$in_path/chr${chr}.bed

    save_file=$save_path/chr${chr}.csv
    > $save_file

    # 运行循环
    for (( start=0; start<=max_length-window_size; start+=step_size )); do
        end=$((start + window_size))
        samp_sum=0  # 初始化samp_sum
        cg_sum=0    # 初始化cg_sum

        # 计算samp_sum和cg_sum
        samp_sum=$(awk -v "st=$start" -v "en=$end" '{if($2 >= st && $3 <= en) sum += $4} END{if(sum == "") sum = 0; print sum}' $sample_bed_file)
        cg_sum=$(awk -v "st=$start" -v "en=$end" '{if($2 >= st && $3 <= en) count++} END{print count}' $cg_bed_file)

        # 检查除数是否为0
        if [ "$cg_sum" -eq 0 ]; then
            ratio="undefined"
        else
            ratio=$(echo "scale=4; $samp_sum / $cg_sum" | bc -l)
        fi

        # 将结果存储在数组中
        results+=("chr$chr,$start,$end,$ratio")
    done

    # 一次性将所有结果写入文件
    printf "%s\n" "${results[@]}" > "$save_file"

    # 清空结果数组以用于下一个染色体
    unset results
    declare -a results

done


