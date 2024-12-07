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

sample_id_list=sys.argv[1].split(' ')[1:]
print(sample_id_list)
reads_tag_list=[]

for y in sample_id_list:
    reads_tag_list.append(y[-2:])

sample_id=""
for i in sample_id_list:
    sample_id+="_"+i

vcf_file =path+"/data/joint_multi/difference"+sample_id+"/joint"+sample_id+".vcf"
vcf_reader = open(vcf_file,'r')
type_list=['INS', 'DEL', 'INV', 'DUP', 'BND']

for i in type_list:
    file=open(path+"/data/joint_multi/difference"+sample_id+"/joint"+sample_id+"_"+i+".txt",'w')
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

    format_ = record.split('\t')[8]
    samples = record.split('\t')[9]
    id=record.split('\t')[2]

    # important infor
    # SVLEN insert reads length
    svlen=info.split(';')[2].split('=')[1]
    h=0
    reads_id_list=info.split(';')[5].split('=')[1].split(',')
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

        svtype=info.split(';')[1].split('=')[1]
        for ty in type_list:
            if(ty==svtype):
                writer=open(path+"/data/joint_multi/difference"+sample_id+"/joint"+sample_id+"_"+ty+".txt",'a+')
                # sniffle_id sample_id chr position insert_reads_length variation_site_format variation_site_type
                writer.write(id+'\t'+chromosome+'\t'+str(position)+'\t'+svlen+'\t'+format_+'\t'+samples)

                break
            else:
                continue


        else:
            continue

txt2bed(sample_id,'INS')
txt2bed(sample_id,'DEL')