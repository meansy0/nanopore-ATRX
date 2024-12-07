import subprocess
import csv
import os

def csvBirth(meth_rate,save_path):
    if meth_rate==0:
        depth=''
    else:
        depth=f"{str(meth_rate)}."
    # 染色体列表
    chromosomes_num = [f"chr{i}" for i in range(1, 25)]
    chromosomes=[]
    for chr in chromosomes_num:
        if "23" in chr:
            chromosomes.append('chrX')
        elif "24" in chr:
            chromosomes.append('chrY')
        else:
            chromosomes.append(chr)
        
    # 用于存储行数的字典
    lines_count = {}

    # 对每个染色体的grow和diss文件进行行数统计
    for chrom in chromosomes:
        grow_file = f"{chrom}.{depth}modifis_grow.txt"  # 假设文件名为chr1_grow.txt, chr2_grow.txt, ...
        diss_file = f"{chrom}.{depth}modifis_disappear.txt"  # 假设文件名为chr1_diss.txt, chr2_diss.txt, ...
        
        # 使用subprocess调用wc -l命令
        grow_lines = subprocess.check_output(["wc", "-l", grow_file]).split()[0].decode('utf-8')
        diss_lines = subprocess.check_output(["wc", "-l", diss_file]).split()[0].decode('utf-8')
        
        # 保存行数
        lines_count[chrom] = {'grow': grow_lines, 'diss': diss_lines}

    # 写入CSV文件

    with open(f'{save_path}{depth}chrMeth.growth.loss.csv', 'w', newline='') as csvfile:
        fieldnames = ['Chromosome', 'Growth', 'Loss']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for chrom, counts in lines_count.items():
            writer.writerow({'Chromosome': chrom, 'Growth': counts['grow'], 'Loss': counts['diss']})

    print("CSV文件已生成。")

def main():
    group_number_list=['s31222_a509','s31222_a509_2','s31222_a509_3']
    for group_number in group_number_list:
        workpath=f"/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter2Reads/{group_number}/three_locations"
        data_path="/public/home/xiayini/project/nanopore_ATRX/5_statistc/results/fig2/data/"
        save_path=f"{data_path}{group_number}/"
        os.system(f"mkdir -p {save_path}")

        os.chdir(workpath)
        csvBirth(0,save_path)
        csvBirth(0.5,save_path)
    

if __name__=='__main__':
    main()