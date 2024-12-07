
import os
def judgeMeth(meth_rate,filter_meth_file,out_file_path,judge_list):
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
                if(i==1 and values>meth_rate):
                    count+=1
            if(count==sample_len):
                out_file.write(line)
    out_file.close()
    in_file.close() 

def classifyMeth(meth_rate,chr,filter_meth_file,new_folder_path,sample_name_list):
    # no>yes：Modifications grow
    if meth_rate==1e-6:
        grow_file=f"{new_folder_path}chr{chr}.modifis_grow.txt"
    else:
        grow_file=f"{new_folder_path}chr{chr}.{meth_rate}.modifis_grow.txt"
    judge_list1=[0,1]
    judgeMeth(meth_rate,filter_meth_file,grow_file,judge_list1)
    # yes>no：modifications disappear

    if meth_rate==1e-6:
        disappear_file=f"{new_folder_path}chr{chr}.modifis_disappear.txt"
    else:
        disappear_file=f"{new_folder_path}chr{chr}.{meth_rate}.modifis_disappear.txt"

    judge_list2=[1,0]
    judgeMeth(meth_rate,filter_meth_file,disappear_file,judge_list2)

def main():
    # sample_name_list=["s31222","a509_3"]
    sample_name_list=["a509","s31222"]
    filter_read_num=2
    # meth_rate=0.5
    meth_rate=1e-6
    old_folder_path=f"/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter{str(filter_read_num)}Reads"  
    folder_path=old_folder_path+'/'+"_".join(sample_name_list)     
    new_folder_path = folder_path + '/three_locations/'
    
    for int_chr in range(1,25):
        if(int_chr>=23):
            if(int_chr==24):
                chr='X'
            else:
                chr='Y'
        else:
            chr=str(int_chr)

        filter_meth=f"{new_folder_path}chr{chr}.filter.txt"
       
        if os.path.isfile(filter_meth) and os.path.getsize(filter_meth):
        # if not (os.path.isfile(filter_meth)==False and os.path.getsize(filter_meth) > 0):  
            classifyMeth(meth_rate,chr, filter_meth, new_folder_path, sample_name_list)

if __name__ == "__main__":
    main()




