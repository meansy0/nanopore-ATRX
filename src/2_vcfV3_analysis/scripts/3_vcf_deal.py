import pysam
import os

def vcfDeal(analysis_version,sample_list,sup_reads,samp_depth_list) :
    join_sample="_".join(sample_list)
    root_path='/public/home/xiayini/project/nanopore_ATRX/'

    path=f'{root_path}{analysis_version}/data/joint_multi/difference_{join_sample}/'

    input_vcf = path+"cutesv.vcf"
    cache_vcf=path+"cutesv.cache.vcf"
    output_vcf1 = path+"cutesv.filter.1.read.vcf"
    output_vcf2 = path+"cutesv.filter.2.read.vcf"

    # 构建完整的 Shell 命令
    command = (
        f"grep '^#' {input_vcf} > {cache_vcf} && "
        f"grep -v '^#' {input_vcf} | grep -v Un | grep -v alt | grep -v random | grep PASS >> {cache_vcf}"
    )
    # 使用 os.system 运行命令
    os.system(command)
    # 打开输入和输出文件
    with pysam.VariantFile(cache_vcf, "r") as vcf_in, pysam.VariantFile(output_vcf1, "w", header=vcf_in.header) as vcf_out1, pysam.VariantFile(output_vcf2, "w", header=vcf_in.header) as vcf_out2:
        for record in vcf_in:
            # 获取INFO字段中的RNAMES值
            rnames = record.info.get("RNAMES")
            if rnames is not None:
                count_samp1 = sum(1 for rname in rnames if rname.endswith(sample_list[0]))
                depth1=int(samp_depth_list[0])
                count_samp2 = sum(1 for rname in rnames if rname.endswith(sample_list[1]))
                depth2=int(samp_depth_list[1])

                sup_count_samp1=count_samp1/depth1
                sup_count_samp2=count_samp2/depth2
                if sup_count_samp1==0 and sup_count_samp2>=sup_reads:
                    vcf_out1.write(record)
                
                if sup_count_samp1>=sup_reads and sup_count_samp2==0:
                    vcf_out2.write(record)
                
                    
    os.remove(cache_vcf)

if __name__=='__main__': 
    sup_reads=4
    analysis_version='2_vcfV3_analysis'
    # s31222 a509 a509_2 a509_3
    depth_list=[1,1,1,1]

    sample_list=["a509","s31222"]
    samp_depth_list=[depth_list[0],depth_list[1]]
    vcfDeal(analysis_version,sample_list,sup_reads,samp_depth_list) 

    # sample_list=["s31222","a509"]
    # samp_depth_list=[depth_list[0],depth_list[1]]
    # vcfDeal(analysis_version,sample_list,sup_reads,samp_depth_list) 

    # sample_list=["s31222","a509_2"]
    # samp_depth_list=[depth_list[0],depth_list[2]]
    # vcfDeal(analysis_version,sample_list,sup_reads,samp_depth_list) 

    # sample_list=["s31222","a509_3"]
    # samp_depth_list=[depth_list[0],depth_list[3]]
    # vcfDeal(analysis_version,sample_list,sup_reads,samp_depth_list) 

