# python /public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/scripts/join_comp/check_meth_compu.py |less

import sys
import subprocess

def custom_sort_key(line):
    fields = line.split()
    fifth_column = float(fields[4].split(':')[1])
    return (-fifth_column, line)


filter_reads="4"
folder_path=f"/public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/results/filter{filter_reads}Reads/"

sample_list=["s31222","a509","a509_2"]

filter_rate=0.2

for chr in range(1,25):
    if(chr>=23):
        if(chr==23):
            chr_name='X'
        else:
            chr_name='Y'
    else:
        chr_name=str(chr)

    file_type_list=["filter","modifis_grow","modifis_disappear"]
    for file_type in file_type_list:
        file_path = folder_path+"_".join(sample_list)+f"/three_locations/chr{chr_name}.{file_type}.txt"

        all_count =int(subprocess.getoutput("wc -l %s" % file_path).split()[0])
        with open(file_path, 'r') as f:
            lines = f.readlines()

        sorted_lines = sorted(lines, key=custom_sort_key)
        count=0
        count1=0
        count2=0
        if("grow" in file_type):
            for line in sorted_lines:
                if(float(line.split('\t')[4].split(':')[1])>=filter_rate):
                    # sys.stdout.write(line)
                    count+=1
        if("disap" in file_type):
            for line in sorted_lines:
                if(float(line.split('\t')[2].split(':')[1])>=filter_rate):
                    # sys.stdout.write(line)
                    count1+=1  
                if(float(line.split('\t')[3].split(':')[1])>=filter_rate):
                    # sys.stdout.write(line)
                    count2+=1            
        rate=float(count/all_count)
        rate1=float(count1/all_count)
        rate2=float(count2/all_count)
        if("grow" in file_type):
            print(f"chr{chr_name}-{file_type}:{rate}")
        if("disap" in file_type):
            print(f"chr{chr_name}-{file_type}:{rate1}&{rate2}")

