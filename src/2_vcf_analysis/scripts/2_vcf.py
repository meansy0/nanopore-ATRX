import pysam
import os

# 输入和输出文件路径
sample_list=["s31222","a509","a509_2"]
# sample_list=["s31222","a509_2","a509_3"]
sup_reads=2
# sample_list=["a509","s31222"]

join_sample="_".join(sample_list)
if sup_reads==2:

    path="/public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis/data/joint_multi_supReads2/difference_"+join_sample+"/"
else:
    path="/public/home/xiayini/project/nanopore_ATRX/2_vcf_analysis/data/joint_multi/difference_"+join_sample+"/"

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


# os.system("cat "+input_vcf+" |grep -v Un|grep -v alt|grep -v random|grep PASS > "+cache_vcf)

# 打开输入和输出文件
with pysam.VariantFile(cache_vcf, "r") as vcf_in, pysam.VariantFile(output_vcf1, "w", header=vcf_in.header) as vcf_out1, pysam.VariantFile(output_vcf2, "w", header=vcf_in.header) as vcf_out2:
    for record in vcf_in:
        # 获取INFO字段中的RNAMES值
        rnames = record.info.get("RNAMES")
        rnames_len=len(rnames)

        if rnames is not None:
            # 检查所有RNAMES值
            if len(sample_list)==3:
                birth_have_all_rnames_end= all(rname.endswith((sample_list[2])) for rname in rnames)
                birth_no_all_rnames_end = not any(rname.endswith((sample_list[0],sample_list[1])) for rname in rnames)

                disp_no_all_rnames_end= not any(rname.endswith((sample_list[2])) for rname in rnames)
                disp_have_all_rnames_end1 = any(rname.endswith(sample_list[0]) for rname in rnames)
                disp_have_all_rnames_end2 = any(rname.endswith(sample_list[1]) for rname in rnames)

                if birth_have_all_rnames_end and birth_no_all_rnames_end:
                    
                    vcf_out1.write(record)
                if disp_no_all_rnames_end and disp_have_all_rnames_end1 and disp_have_all_rnames_end2:
                    vcf_out2.write(record)
            else:
                birth_have_all_rnames_end= all(rname.endswith((sample_list[1])) for rname in rnames)
                birth_no_all_rnames_end = not any(rname.endswith((sample_list[0])) for rname in rnames)

                disp_no_all_rnames_end= not any(rname.endswith((sample_list[1])) for rname in rnames)
                disp_have_all_rnames_end = any(rname.endswith(sample_list[0]) for rname in rnames)
                if birth_have_all_rnames_end and birth_no_all_rnames_end:
                    
                    vcf_out1.write(record)
                if disp_no_all_rnames_end and disp_have_all_rnames_end:
                    vcf_out2.write(record)
# os.remove(cache_vcf)

