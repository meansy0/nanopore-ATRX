import os
import re
import subprocess
import math

def calculate_gc_content(sequence):
    gc_count = sum(1 for base in sequence if base in ['G', 'C','g','c'])
    return gc_count ,len(sequence) if sequence else 0
def extract_svlen(info_field):
    parts = info_field.split(';')
    svlen_entry = next((item for item in parts if item.startswith('SVLEN=')), None)
    if svlen_entry:
        svlen_value = svlen_entry.split('=')[1]
        return svlen_value
    return None

def read_fasta(filename):
    with open(filename, 'r') as file:
        sequences = {}
        current_seq = ''
        current_name = ''
        for line in file:
            if line.startswith('>'):
                if current_seq:
                    sequences[current_name] = current_seq
                    current_seq = ''
                current_name = line[1:].strip()
            else:
                current_seq += line.strip()
        if current_seq:
            sequences[current_name] = current_seq
    return sequences


def read_bed(filename):
    sequences = {}
    with open(filename, 'r') as file:
        for line in file:
            if line.strip():  # 确保排除空行
                parts = line.strip().split('\t')  # 使用制表符分割每行
                if len(parts) >= 5:  # 确保行中至少有五个元素
                    chrom = parts[0]  # 染色体名
                    start = parts[1]  # 起始位置
                    end = parts[2]    # 终止位置
                    seq = parts[3]    # 序列
                    name = f"{chrom}:{start}-{end}"  # 创建以 chr:start-end 格式的名字
                    sequences[name] = seq
    return sequences




def vcfInfor(vcf_file,out_file):
    gc_contents = []
    out_write=open(out_file,'w')
    with open(vcf_file, 'r') as file:
        for line in file:
            if line.startswith('#'):
                continue  # 跳过注释行
            parts = line.strip().split('\t')
            sv_type=parts[2].split('.')[1]

            svlen = extract_svlen(parts[7])
            
            if len(parts) > 4: 
                ref=parts[3]
                alt=parts[4]
                out_write.write(f'{parts[0]}\t{parts[1]}\t{sv_type}\t{ref}\t{alt}\t{svlen}\n')
    out_write.close()
        
def getBed(infor_file,insert_bed_file,delete_bed_file,windows):
    out_write1=open(insert_bed_file,'w')
    out_write2=open(delete_bed_file,'w')
    with open(infor_file, 'r') as file:
        for line in file:
            list0=line.split('\t')
            numbers = re.findall(r"\d+", list0[5])
            seq_len = int(numbers[0]) if numbers else None
            # print(seq_len)
            if seq_len:
                test=math.ceil(int(seq_len) / 2)

            if(list0[2]=='INS'):
                seq=list0[4]
                
                # out_write1.write(f"{list0[0]}\t{str(int(list0[1])-windows)}\t{str(int(list0[1])+windows)}\t{seq}\t{list0[2]}\n")  
                out_write1.write(f"{list0[0]}\t{str(int(list0[1])-test)}\t{str(int(list0[1])+test)}\t{seq}\t{list0[2]}\n")  
                             
            elif(list0[2]=='DEL'):
                seq=list0[3]
                # out_write2.write(f"{list0[0]}\t{str(int(list0[1])-windows)}\t{str(int(list0[1])+windows+int(seq_len))}\t{seq}\t{list0[2]}\n")                
                out_write2.write(f"{list0[0]}\t{str(int(list0[1])-test)}\t{str(int(list0[1])+test+int(seq_len))}\t{seq}\t{list0[2]}\n")                
            else:
                continue


def getfasta(genome_fasta_file,bed_file,fasta_file):
    # 定义命令的各个部分
    command = "bedtools getfasta"
    # 构建完整命令
    full_command = f"{command} -fi {genome_fasta_file} -bed {bed_file} -fo {fasta_file}"

    # 运行命令
    try:
        subprocess.run(full_command, check=True, shell=True)
        print("命令执行成功")
    except subprocess.CalledProcessError as e:
        print(f"命令执行失败: {e}")

def main():

    # Replace 'your_file.fasta' with your file name
    # 替换为您的 VCF 文件路径
    path='/public/home/xiayini/project/nanopore_ATRX/5_statistc/data/'
    windows=100
    group_list=['s31222_a509','s31222_a509_2','s31222_a509_3']
    for group in group_list:
        vcf_file=f'/public/home/xiayini/project/nanopore_ATRX/2_vcfV3_analysis/data/joint_multi/difference_{group}/cutesv.filter.1.read.vcf'
        infor_file=f'{path}{group}/sv.alt.infor.txt'
        insert_bed_file=f'{path}{group}/sv.alt.insert.bed'
        delete_bed_file=f'{path}{group}/sv.alt.delete.bed'
        vcfInfor(vcf_file,infor_file)
        getBed(infor_file,insert_bed_file,delete_bed_file,windows)
        os.remove(infor_file)
        genome_fasta='/public/home/xiayini/reference/chm13v2.0.name.fa'
        insert_fasta_file=f'{path}{group}/sv.alt.insert.fasta'

        getfasta(genome_fasta,insert_bed_file,insert_fasta_file)
        fasta_sequences=read_fasta(insert_fasta_file) 
        bed_sequences=read_bed(insert_bed_file)      

        save_insert_gc_content=f'{path}{group}/sv.alt.insert.gc.csv'
        out_csv_insert=open(save_insert_gc_content,'w')
        out_csv_insert.write(f'svname,old_gc_content,new_gc_content\n')
        for bed_key, bed_seq in bed_sequences.items():
            # 从 BED 名称创建一个与 FASTA 名称相匹配的键
            fasta_key = f"{bed_key}"  # 假设 FASTA 名称以 '>' 开头
            if fasta_key in fasta_sequences:
                fasta_seq = fasta_sequences[fasta_key]
                # 现在 bed_seq 和 fasta_seq 是对应的序列
                bed_gc_content,bed_all_content = calculate_gc_content(bed_seq)
                fasta_gc_content,fasta_all_content = calculate_gc_content(fasta_seq)
                old_gc_percent=fasta_gc_content/fasta_all_content*100
                # now_gc_percent=(bed_gc_content+fasta_gc_content)/(bed_all_content+fasta_all_content)*100
                now_gc_percent=(bed_gc_content)/(bed_all_content)*100
                out_csv_insert.write(f"{fasta_key},{old_gc_percent:.2f},{now_gc_percent:.2f}\n")
                # print(f"{fasta_key}: 原gc含量={old_gc_percent:.2f}% 现gc含量={now_gc_percent:.2f}%")
                # print(f"对应的序列：BED序列 = {bed_seq}, FASTA序列 = {fasta_seq}")
            else:
                print(f"找不到对应的 FASTA 序列: {fasta_key}")
        
        delete_fasta_file=f'{path}{group}/sv.alt.delete.fasta'
        getfasta(genome_fasta,delete_bed_file,delete_fasta_file)
        fasta_sequences=read_fasta(delete_fasta_file) 
        bed_sequences=read_bed(delete_bed_file)    

        save_delte_gc_content=f'{path}{group}/sv.alt.delete.gc.csv'
        out_csv_delete=open(save_delte_gc_content,'w')
        out_csv_delete.write(f'svname,old_gc_content,new_gc_content\n')
        for bed_key, bed_seq in bed_sequences.items():
            # 从 BED 名称创建一个与 FASTA 名称相匹配的键
            fasta_key = f"{bed_key}"  # 假设 FASTA 名称以 '>' 开头
            if fasta_key in fasta_sequences:
                fasta_seq = fasta_sequences[fasta_key]
                # 现在 bed_seq 和 fasta_seq 是对应的序列
                bed_gc_content,bed_all_content = calculate_gc_content(bed_seq)
                fasta_gc_content,fasta_all_content = calculate_gc_content(fasta_seq)
                old_gc_percent=fasta_gc_content/fasta_all_content*100
                now_gc_percent=(bed_gc_content)/(bed_all_content)*100
                # now_gc_percent=(fasta_gc_content-bed_gc_content)/(fasta_all_content-bed_all_content)*100
                out_csv_delete.write(f"{fasta_key},{old_gc_percent:.2f},{now_gc_percent:.2f}\n")
                # print(f"{fasta_key}: 原gc含量={old_gc_percent:.2f}% 现gc含量={now_gc_percent:.2f}%")
                # print(f"对应的序列：BED序列 = {bed_seq}, FASTA序列 = {fasta_seq}")
            else:
                print(f"找不到对应的 FASTA 序列: {fasta_key}")
        

if __name__=='__main__':
    main()