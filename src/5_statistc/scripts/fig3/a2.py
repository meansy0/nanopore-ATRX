import os
import re
import subprocess
import math

def calculate_gc_content(sequence):
    gc_count = sum(1 for base in sequence if base in ['G', 'C','g','c'])
    return gc_count ,len(sequence) if sequence else 0

def read_methtxt(filename):
    sequences = {}
    with open(filename, 'r') as file:
        for line in file:
            if 'allCG' in line:
                continue
            if line.strip():  # 确保排除空行
                parts = line.strip().split('\t')  # 使用制表符分割每行
                if len(parts) >= 5:  # 确保行中至少有五个元素
                    chrom = parts[0]  # 染色体名
                    start = parts[1]  # 起始位置
                    end = parts[2]    # 终止位置
                    name = f"{chrom}:{start}-{end}"  # 创建以 chr:start-end 格式的名字

                    if name in  sequences:
                        sequences[name] += 1
                    else:
                        sequences[name] = 1

    return sequences


def readcgtxt(filename):
    sequences = {}
    with open(filename, 'r') as file:
        for line in file:
            if line.strip():  # 确保排除空行
                parts = line.strip().split('\t')  # 使用制表符分割每行
                if len(parts) >= 4:  # 确保行中至少有4个元素
                    chrom = parts[0]  # 染色体名
                    start = parts[1]  # 起始位置
                    end = parts[2]    # 终止位置
                    name = f"{chrom}:{start}-{end}"  # 创建以 chr:start-end 格式的名字

                    sequences[name] = parts[3].split('\n')

    return sequences  

def main():
    path="/public/home/xiayini/project/nanopore_ATRX/5_statistc/data/s31222_a509_2/fig3/"
    # sv_type:INS/DEL
    sv_type="INS"
    # meth_type:all/growth
    meth_type='all'
    # extend_bp:0/100/200/300
    extend_bp='200'
    in_path=f"{path}{extend_bp}_extend_bp/{sv_type}_{meth_type}/"
    cg_txt_file=f"{in_path}{meth_type}.sv_cg_content.txt"
    meth_txt_file=f"{in_path}{meth_type}.meth_in_sv.bed"
    # fasta_sequences=read_fasta(fasta_file)
    meth_seqs=read_methtxt(meth_txt_file)
    cg_seqs=readcgtxt(cg_txt_file)
    out_file=f"{in_path}{meth_type}.methRate.txt"
    out1=open(out_file,'w')
    out1.write(f"name,methRate,meth,cg\n")
    for key,cg_count in cg_seqs.items():
        if key in meth_seqs:
            meth=meth_seqs[key]
            # print(key,meth_seqs[key],int(cg_count[0]))
        else:
            meth=0
            # print(key,0,int(cg_count[0]))
        cg=int(cg_count[0])
        rate=meth/cg
        out1.write(f"{key},{rate:.3f},{meth},{cg}\n")

            # 从 BED 名称创建一个与 FASTA 名称相匹配的键
    # print(sequences)
    # for fasta_key, fasta_seq in fasta_sequences.items():
    #     gc_content,atcg_content = calculate_gc_content(fasta_seq)
        

if __name__=='__main__':
    main()