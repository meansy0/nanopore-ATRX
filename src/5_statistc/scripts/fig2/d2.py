
import subprocess
import os

group='s31222_a509_2'
in_path=f"/public/home/xiayini/project/nanopore_ATRX/5_statistc/data/{group}/fig2/d/annotation"
refer_path=f"/public/home/xiayini/reference/chm12v2.0/cg_chr"
for chr_iter in range(1, 25):
    if chr_iter == 23:
        chr_num = 'X'
    elif chr_iter == 24:
        chr_num = 'Y'
    else:
        chr_num = str(chr_iter)

    meth_annotation_bed=f"{in_path}/chr{chr_num}.ano.bed"
    save_bed=f"{in_path}/chr{chr_num}.ano.meth.bed"
    out1=open(save_bed,'w')
    

    cg_refer_bed=f"{refer_path}/chr{chr_num}.c.g.bed"
    in1=open(meth_annotation_bed,'r')

    for line in in1:
        part=line.split('\t')
        start=int(part[1])
        end=int(part[2])
        # 构建并执行命令
        cmd = f"awk -v start={start} -v end={end} '{{if($2>=start && $3<=end) print $0}}' {cg_refer_bed} | wc -l"
        process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        output, error = process.communicate()

        if process.returncode == 0:
            # 将输出转换为整数
            count = int(output.strip())
            meth_rate=str(round(float(part[3])/count,4))
            part[3]=meth_rate
            part_str="\t".join(part)
            out1.write(part_str)
        else:
            print("Error executing command:", error)        
# results=subprocess.run(full_command, check=True, shell=True,capture_output=True)




# 现在你可以使用 line_count 变量
