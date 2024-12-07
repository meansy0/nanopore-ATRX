import pandas as pd

group_num = 's31222_a509_3'
for chr_iter in range(1, 25):
    if chr_iter == 23:
        chr_num = 'X'
    elif chr_iter == 24:
        chr_num = 'Y'
    else:
        chr_num = str(chr_iter)

    bed2_path = f'/public/home/xiayini/reference/chm12v2.0/cg_chr/chr{chr_num}.c.g.bed'
    bed1_path = f'/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter2Reads/{group_num}/three_locations/chr{chr_num}.filter.bed'
    
    # 读取 BED 文件
    bed1 = pd.read_csv(bed1_path, sep='\t', header=None, names=['chr', 'start', 'end'])
    bed2 = pd.read_csv(bed2_path, sep='\t', header=None, names=['chr', 'start', 'end'])

    # 设置窗口大小
    window_size = 200
    step_size=50

    # 获取所有可能的染色体
    chromosomes = set(bed1['chr']).union(set(bed2['chr']))

    # 结果列表
    results = []

    # 对每个染色体进行处理
    for chr in chromosomes:
        # 获取该染色体的最大长度
        max_length = max(bed1[bed1['chr'] == chr]['end'].max(), bed2[bed2['chr'] == chr]['end'].max())

        # 遍历窗口
        for start in range(0, max_length - window_size + 1, step_size):
            end = start + window_size

            # 计算落在当前窗口内的行数
            count_bed1 = ((bed1['chr'] == chr) & (bed1['start'] >= start) & (bed1['end'] <= end)).sum()
            count_bed2 = ((bed2['chr'] == chr) & (bed2['start'] >= start) & (bed2['end'] <= end)).sum()

            # 避免除以零
            ratio = count_bed1 / count_bed2 if count_bed2 > 0 else 'undefined'

            # 添加到结果中
            results.append({'chr': chr, 'start': start, 'end': end, 'ratio': ratio})

    # 转换为 DataFrame 并输出结果
    result_df = pd.DataFrame(results)
    save_path=f"/public/home/xiayini/project/nanopore_ATRX/5_statistc/data/{group_num}/fig2/d"
    # 将结果保存到 CSV 文件
    output_file_path = f'{save_path}/chr{chr_num}_ratios.csv'  # 指定输出文件路径
    result_df.to_csv(output_file_path, index=False, sep='\t')
    # print(result_df)


