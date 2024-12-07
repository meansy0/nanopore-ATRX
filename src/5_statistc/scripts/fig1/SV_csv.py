import subprocess
import csv
import os


def getSVcount(bed_file,sv_type):

    try:
        # 执行命令获取符合条件的行数
        grep_command = f"grep -c '{sv_type}' {bed_file}"
        sv_count = subprocess.check_output(grep_command, shell=True)
        sv_count = int(sv_count.strip()) if sv_count else 0
    except subprocess.CalledProcessError as e:
        print(f"Error executing command: {e}")
        sv_count = 0  # 如果出现错误，默认设置为0

    return sv_count
    

sv_type_list=['BND',"DEL",'DUP','INS','INV']
path="/public/home/xiayini/project/nanopore_ATRX/2_vcfV2_analysis/data/joint_multi_supReads2/"
# 定义样本ID和对应的bed文件
sample1="s31222_a509"
sample2="s31222_a509_2_a509_3"

new_sample_files = {
    "ATRX-P7vsP0": f"{path}difference_{sample1}/",
    "ATRX-P16vsP7": f"{path}difference_{sample2}/"
}

# 创建一个空的结果列表
results = []

# 对每个样本执行命令并获取结果
for sample_id, sample_path in new_sample_files.items():
    new_sv_list=[]
    missing_sv_list=[]
    for i in range(1,3):
        new_bed_id=f"cutesv.filter.{str(i)}.read.bed"
        bed_file=f"{sample_path}{new_bed_id}"
        for sv_type in sv_type_list:
            if i==1:
                new_sv=getSVcount(bed_file,sv_type)
                new_sv_list.append(new_sv)
            else:
                missing_sv=getSVcount(bed_file,sv_type)
                missing_sv_list.append(missing_sv)

    
    # 计算 total_SV
    new_total_sv = sum(new_sv_list)
    missing_total_sv = sum(missing_sv_list)
    
    # 将结果添加到结果列表中
    results.append([sample_id, new_total_sv]+new_sv_list+[missing_total_sv]+missing_sv_list)
    new_total_sv=0
    missing_total_sv=0

# 将结果写入CSV文件
with open('/public/home/xiayini/project/nanopore_ATRX/5_statistc/scripts/SV.csv', 'w', newline='') as csvfile:
    csvwriter = csv.writer(csvfile)
    
    # 写入CSV文件头部
    # ['BND',"DEL",'DUP','INS','INV']
    csvwriter.writerow(['SampleID', 'new_total_SV','new_BND_SV','new_DEL_SV', 'new_DUP_SV','new_INS_SV','new_INV_SV','missing_total_SV','missing_BND_SV','missingDEL_SV', 'missing_DUP_SV','missing_INS_SV','missing_INV_SV'])
    
    # 写入每行数据
    csvwriter.writerows(results)


