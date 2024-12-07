from collections import defaultdict
import subprocess
import os

def getThreeLoactionsData(chr, folder_path, sample_number):
    in_file = folder_path + '/chr' + chr + '.merge.pileup'
    out_folder = folder_path + '/three_locations/'

    if not os.path.exists(out_folder):
        os.makedirs(out_folder)

    out_file = out_folder + 'chr' + chr + '.pileup'

    if os.path.exists(in_file):
        tmp_file=out_folder + 'chr' + chr + '.cache.pileup'
        os.system(f"awk -v num={sample_number} '{{samples[$1\":\"$2]++; lines[$1\":\"$2] = lines[$1\":\"$2] $0 \"\\n\"}} END {{for (key in samples) {{if (samples[key] == num) print lines[key]}}}}' {in_file} > {out_file}")
        command2=f"grep -v '^$' -i {out_file} > {tmp_file} && mv {tmp_file} {out_file}"

        subprocess.run(command2,shell=True)
        return out_file
    else:
        print("chr" + chr + " not exists, skip~")
        return 0

def findMeth(chr,three_meth_file,new_folder_path,sample_number,sample_name_list):
    out_file_path=f"{new_folder_path}chr{chr}.filter.txt"
    out_write=open(out_file_path,'w')
    counts=1
    chr_name=''
    location=''
    sample_list=[]
    meth_list=[]
    depth_list=[]
    with open(three_meth_file,'r') as in_file:
        for line in in_file:
            if(counts<=sample_number):
                if(counts==1):
                    chr_name=line.split('\t')[0]
                    location=line.split('\t')[1]
                sample_list.append(line.split('\t')[5].split('\n')[0])
                meth_list.append(line.split('\t')[4])
                depth_list.append(line.split('\t')[3])
                counts+=1
            else:
                if not all(element == '0' for element in meth_list):
                    # not all 0
                    # print(meth_list)
                    out_write.write(f"{chr_name}\t{location}")

                    # list2_to_list3 = {item: meth_list[i] for i, item in enumerate(sample_list)}
                    # sorted_list2 = [item for item in sample_name_list]
                    # # sorted_list3 = [list2_to_list3[item] for item in sorted_list2]
                    # sorted_list3 = [list2_to_list3.get(item, "Default Value") for item in sorted_list2]

                    # 创建一个字典，将list1中的元素与其索引位置关联起来
                    index_mapping = {value: index for index, value in enumerate(sample_name_list)}

                    # 对list2进行排序，使用list1的顺序作为排序依据
                    sorted_list2 = sorted(sample_list, key=lambda x: index_mapping[x])
                    # 使用相同的排序顺序对list3和list4进行操作
                    sorted_list3 = [meth_list[index_mapping[value]] for value in sorted_list2]
                    sorted_list4 = [depth_list[index_mapping[value]] for value in sorted_list2]



                    for sample,meth,depth in zip(sorted_list2,sorted_list3,sorted_list4):
                        out_write.write(f"\t{sample}:{float(meth):.3f},{str(depth)}")
                    sample_list,meth_list,depth_list=[],[],[]
                    sorted_list2,sorted_list3,sorted_list4=[],[],[]

                    out_write.write("\n")
                chr_name=''
                location=''
                counts=1

                chr_name=line.split('\t')[0]
                location=line.split('\t')[1]
                sample_list=[]
                meth_list=[]

                sample_list.append(line.split('\t')[5].split('\n')[0])
                meth_list.append(line.split('\t')[4])
                depth_list.append(line.split('\t')[3])
                counts+=1     
    return out_file_path

def judgeMeth(filter_meth_file,out_file_path,judge_list):
    out_file=open(out_file_path,'w')
    with open(filter_meth_file,'r') as in_file:
        for line in in_file:
            sample_len=len(judge_list)
            info_list=line.rstrip('\n').split('\t')[2:]
            count=0
            for i,j in zip(judge_list,info_list):
                values=float(j.split(':')[1].split(',')[0])
                if(i==0 and values< 1e-6):
                    count+=1
                if(i==1 and values>1e-6):
                    count+=1
            if(count==sample_len):
                out_file.write(line)
    out_file.close()
    in_file.close()                


def classifyMeth(chr,filter_meth_file,new_folder_path,sample_name_list):
    # no>yes：Modifications grow
    grow_file=f"{new_folder_path}chr{chr}.modifis_grow.txt"
    judge_list1=[0,0,1]
    judgeMeth(filter_meth_file,grow_file,judge_list1)
    # yes>no：modifications disappear
    disappear_file=f"{new_folder_path}chr{chr}.modifis_disappear.txt"
    judge_list2=[1,1,0]
    judgeMeth(filter_meth_file,disappear_file,judge_list2)


# if __name__=="__main__":

    # folder_path="/public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/results/s31222_a509_a509_2"
    # sample_name_list=["s31222","a509","a509_2"]
    # sample_number=len(sample_name_list)
    # # deal data by chroms
    # for i in range(1,2):
    #     if(i>=23):
    #         if(i==24):
    #             chr='X'
    #         else:
    #             chr='Y'
    #     else:
    #         chr=str(i)
    #     three_locations_file=getThreeLoactionsData(chr,folder_path,sample_number)
    #     # three_locations_file="/public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/results/s31222_a509_a509_2/three_locations/chr1.pileup"
    #     if three_locations_file!=0:
    #         comMeth="/public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/scripts/join_comp/test.sh"
    #         new_folder_path=folder_path + '/three_locations/'
    #         three_meth_file=f"{new_folder_path}chr{chr}.txt"
    #         os.system(f"bash {comMeth} {three_locations_file} {three_meth_file}")
    #         if(os.path.getsize(three_meth_file)!=0):
    #             filter_meth=findMeth(chr,three_meth_file,new_folder_path,sample_number,sample_name_list)
    #             # filter_meth="/public/home/xiayini/project/nanopore_ATRX/3_methylation_analysis/results/s31222_a509_a509_2/three_locations/chr1.filter.txt"
    #             classifyMeth(chr,filter_meth,new_folder_path,sample_name_list)
                

