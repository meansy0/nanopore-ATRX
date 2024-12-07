import sys


def txt2bed(sample_id,sv_type):
    txt_file=path+"/data/joint_multi/difference"+sample_id+"/joint"+sample_id+"_"+sv_type+".txt"
    in_file=open(txt_file,'r')

    bed_file=path+"/data/joint_multi/difference"+sample_id+"/joint_"+sv_type+".bed"
    out_file=open(bed_file,'w')

    for line in in_file:
        chr=line.split('\t')[1]
        start=int(line.split('\t')[2])-1
        end=start+int(line.split('\t')[3])
        out_file.write(chr+'\t'+str(start)+'\t'+str(end)+'\n')
    
    out_file.close()


path="/public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis"

sample_id_list=["a509","a509_2"]

sample_id=""
for i in sample_id_list:
    sample_id+="_"+i

# vcf_file =path+"/data/joint_multi/difference"+sample_id+"/joint"+sample_id+".vcf"
vcf_file='/public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis/data/joint_multi/cutesv.vcf'
vcf_reader = open(vcf_file,'r')
type_list=['INS', 'DEL', 'INV', 'DUP', 'BND']

for i in type_list:
    file_path=path+"/data/joint_multi/difference"+sample_id+"/joint"+sample_id+"_"+i+".txt"
    file=open(file_path,'w')
    file.close()

# 遍历每个记录并处理
for record in vcf_reader:
    exsits_sample_list=[]
    uniq_exsits_sample_list=[]
    if record.startswith('#'):
        continue
    # 获取FILTER信息
    filter = record.split('\t')[6]
    if(filter!="PASS"):
        continue
    # 获取INFO信息
    info =record.split('\t')[7]

    # 获取chr信息
    chromosome = record.split('\t')[0]
    position = record.split('\t')[1]
    # if(int(position)<=248386359):
    #     continue

    format_ = record.split('\t')[8]
    samples = record.split('\t')[9]
    id=record.split('\t')[2]

    # important infor
    # SVLEN insert reads length
    search_str = "SVLEN="
    if search_str in info:
        svlen=info.split(search_str, 1)[1].split(';', 1)[0]
    h=0

    after_search = info.split("RNAMES=", 1)[1]  # Split at the first occurrence of search_str
    reads_id_list = after_search.split(';', 1)[0].split(',')  # Split at the first semicolon after search_str

    for reads_id in reads_id_list:
        
        if(len(exsits_sample_list)==len(sample_id_list)):
            break

        if(len(reads_id.split('_')[-1])<=1):
            all_reads_id=reads_id.split('_')[-2]+'_'+reads_id.split('_')[-1]
        else:
            all_reads_id=reads_id.split('_')[-1]

        if all_reads_id not in exsits_sample_list:
            exsits_sample_list.append(all_reads_id)
            h+=1
        else:
            h+=1
            continue


    if(len(exsits_sample_list)==1 and sample_id_list[-1]==exsits_sample_list[0]):

        svtype=info.split("SVTYPE=", 1)[1].split(';', 1)[0]
        for ty in type_list:
            if(ty==svtype):
                writer=open(path+"/data/joint_multi/difference"+sample_id+"/joint"+sample_id+"_"+ty+".txt",'a+')
                # sniffle_id sample_id chr position insert_reads_length variation_site_format variation_site_type
                if(svtype!='BND'):
                    writer.write(id+'\t'+chromosome+'\t'+str(position)+'\t'+svlen+'\t'+format_+'\t'+samples)
                else:
                    writer.write(id+'\t'+chromosome+'\t'+str(position)+'\t'+format_+'\t'+samples)

                break
            else:
                continue


        else:
            continue

txt2bed(sample_id,'INS')
txt2bed(sample_id,'DEL')