import pandas as pd

import os

group_num = 's31222_a509_2'
meth_ty='newData'
bed_file=f'/public/home/xiayini/project/nanopore_ATRX/5_statistc/data/{group_num}/fig3/0_extend_bp/DEL_{meth_ty}/{meth_ty}.sv.extend.bed'

window_size = 50
step_size=20

with open(bed_file,'r') as input1:
    next(input1)  # 跳过第一行
    for line in input1:
        part=line.split('\t')
        chr_num=part[0]
        
        lap_window=2*(int(part[2])-int(part[1]))
        region_start = int(part[1])-lap_window  # 替换为你的区域起始位置
        region_end = int(part[2])+lap_window    # 替换为你的区域结束位置

    # for chr_iter in range(1, 25):
    #     if chr_iter == 23:
    #         chr_num = 'X'
    #     elif chr_iter == 24:
    #         chr_num = 'Y'
    #     else:
    #         chr_num = str(chr_iter)

        in_bed2_path = f'/public/home/xiayini/reference/chm12v2.0/cg_chr/{chr_num}.c.g.bed'
        bed2_path=f'/public/home/xiayini/reference/chm12v2.0/cg_chr/cache.c.g.bed'
        df = pd.read_csv(in_bed2_path, sep='\t', header=None)
        # 过滤出符合条件的行
        filtered_df = df[(df[1] >= region_start) & (df[1] <= region_end)]
        os.system(f"> {bed2_path}")
        filtered_df.to_csv(bed2_path, index=False, sep='\t')

        in_bed1_path=f"/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data/{group_num}/{chr_num}.bed"
        # in_bed1_path = f'/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter2Reads/{group_num}/three_locations/{chr_num}.modifis_grow.bed'
        bed1_path = f'/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter2Reads/{group_num}/three_locations/cache.modifis_grow.bed'

        df = pd.read_csv(in_bed1_path, sep='\t', header=None)
        # 过滤出符合条件的行
        result_df = df[(df[1] >= region_start) & (df[1] <= region_end)]
        os.system(f"> {bed1_path}")
        result_df.to_csv(bed1_path, index=False, sep='\t')



        # 读取 BED 文件
        bed1 = pd.read_csv(bed1_path, sep='\t', header=None, names=['chr', 'start', 'end','siteRate'])
        bed2 = pd.read_csv(bed2_path, sep='\t', header=None, names=['chr', 'start', 'end'])


        # 获取所有可能的染色体
        chromosomes = set(bed1['chr']).union(set(bed2['chr']))
        # print(chromosomes)
        # 结果列表
        results = []
        # 指定分析的特定区域

        # 对每个染色体进行处理
        for chr in chromosomes:
            chr=str(chr)
            if str(0) in chr:
                continue
            # 获取该染色体的最大长度
            max_length = max(bed1[bed1['chr'] == chr]['end'].max(), bed2[bed2['chr'] == chr]['end'].max())

            # 遍历窗口
            for start in range(max(region_start, 0), min(region_end, max_length) - window_size + 1, step_size):
                end = start + window_size

                # 计算落在当前窗口内的行数
                total_rate = bed1.loc[(bed1['chr'] == chr) & (bed1['start'] >= start) & (bed1['end'] <= end), 'siteRate'].sum()
                # count_bed1 = ((bed1['chr'] == chr) & (bed1['start'] >= start) & (bed1['end'] <= end)).sum()
                count_bed2 = ((bed2['chr'] == chr) & (bed2['start'] >= start) & (bed2['end'] <= end)).sum()

                # 避免除以零
                ratio = total_rate / count_bed2 if count_bed2 > 0 else 'undefined'

                # 添加到结果中
                results.append({'chr': chr, 'start': start, 'end': end, 'ratio': ratio})

        # 转换为 DataFrame 并输出结果
        result_df = pd.DataFrame(results)
        if not result_df.empty:
            result_df = result_df.sort_values(by='start')
        else:
            continue

        save_path=f"/public/home/xiayini/project/nanopore_ATRX/5_statistc/data/{group_num}/fig3/b/{meth_ty}"
        os.system(f"mkdir -p {save_path}")
        # 将结果保存到 CSV 文件
        output_file_path = f'{save_path}/{chr_num}_{int(part[1])}_{int(part[2])}_sv_ratios.csv'  # 指定输出文件路径
        result_df.to_csv(output_file_path, index=False, sep='\t')
        # print(result_df)

