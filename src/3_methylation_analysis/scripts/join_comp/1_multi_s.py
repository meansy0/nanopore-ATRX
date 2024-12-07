import os
import subprocess
from compuFunctions import getThreeLoactionsData, findMeth, classifyMeth
from multiprocessing import Pool

def sortedFile(chr,sample_list,old_folder_path):

    # 合并文件
    merge_folder_file=old_folder_path+'/'+"_".join(sample_list)
    if not os.path.exists(merge_folder_file):
        os.makedirs(merge_folder_file)

    file_list=[]
    for sample in sample_list:
        file_list.append(old_folder_path+'/'+sample+'/chr'+chr+'.pileup')
    merge_file=merge_folder_file+'/chr'+chr+'.merge.pileup'
    merge_command = f"cat {' '.join(file_list)} > {merge_file}"
    subprocess.run(merge_command, shell=True)

    # 对合并后的文件按第一列和第二列排序
    sort_command = f"sort -k1,1 -k2n,2n {merge_file} -o {merge_file}"
    subprocess.run(sort_command, shell=True)

    return merge_folder_file,merge_file

def process_chromosome(int_chr):

    if(int_chr>=23):
        if(int_chr==24):
            chr='X'
        else:
            chr='Y'
    else:
        chr=str(int_chr)

    
    folder_path, merge_file = sortedFile(chr, sample_name_list, old_folder_path)

    three_locations_file = getThreeLoactionsData(chr, folder_path, sample_number)
    if three_locations_file != 0:
        comMeth = "/public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/scripts/join_comp/test.sh"
        new_folder_path = folder_path + '/three_locations/'
        three_meth_file = f"{new_folder_path}chr{chr}.txt"
        os.system(f"bash {comMeth} {three_locations_file} {three_meth_file}")
        if os.path.getsize(three_meth_file) != 0:
            filter_meth = findMeth(chr, three_meth_file, new_folder_path, sample_number, sample_name_list)
            classifyMeth(chr, filter_meth, new_folder_path, sample_name_list)

if __name__ == "__main__":
    # oringal_folder_path="/public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/data"
    old_folder_path="/public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/results/filter4Reads"
    sample_name_list=["s31222","a509","a509_2"]
    sample_number=len(sample_name_list)

    # chromosome_range = range(23, 25)
    chromosome_range=range(1,25)

    with Pool(processes=4) as pool:  # 这里的进程数可以根据需要进行调整
        pool.map(process_chromosome, chromosome_range)
