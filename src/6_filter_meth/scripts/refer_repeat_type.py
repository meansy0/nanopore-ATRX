import pandas as pd
import subprocess
group_num = 's31222_a509_3'
path=f'/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data/{group_num}' 

for chr_iter in range(1, 25):
    if chr_iter == 23:
        chr_num = 'X'
    elif chr_iter == 24:
        chr_num = 'Y'
    else:
        chr_num = str(chr_iter)

    refer_bed_path = f'/public/home/xiayini/reference/chm12v2.0/cg_chr/chr{chr_num}.c.g.bed'
    txt_path=f'{path}/chr{chr_num}_repeat_intersect.txt'
    out_file=f'{path}/chr{chr_num}_repeat_meth.txt'
    out1=open(out_file,'w')
    # txt_path = f'/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter2Reads/{group_num}/three_locations/chr{chr_num}.filter.bed'
   
    with open(txt_path,'r') as in1:
        for line in in1:
            part=line.split('\t')
            start=int(part[1])
            end=int(part[2])
            meth=float((part[6].split('\n')[0]))
            awk_cmd = f'awk \'$2 >= {start} && $2 < {end}\' {refer_bed_path} | wc -l'

            # 使用subprocess运行awk命令
            result = subprocess.run(awk_cmd, shell=True, text=True, capture_output=True)

            # 获取输出并转换为整数
            cg_count = int(result.stdout.strip()) 
            rate=meth/cg_count
            output_string = '\t'.join(part[0:6])
            out1.write(f"{output_string}\t{str(rate)}\n")



        