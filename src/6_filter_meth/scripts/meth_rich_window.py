import pandas as pd

# 字典用于存储染色体长度
chr_len_dict = {}
chr_len_file = '/public/home/xiayini/reference/chm13v2.0.name.len.txt'

# 读取染色体长度文件
with open(chr_len_file, 'r') as chr_in:
    for line in chr_in:
        chr, len = line.split('\t')[0], int(line.split('\t')[2].split('\n')[0])
        chr_len_dict[chr] = len

print(chr_len_dict)

group_num = 's31222_a509_3'

# 为每个染色体处理文件
for chr_iter in range(1, 25):
    chr_num = 'X' if chr_iter == 23 else 'Y' if chr_iter == 24 else str(chr_iter)
    bed2_path = f'/public/home/xiayini/reference/chm12v2.0/cg_chr/chr{chr_num}.c.g.bed'

    # 一次性读取 bed2 文件
    bed2 = pd.read_csv(bed2_path, sep='\t', header=None, names=['chr', 'start', 'end'])

    for c in range(5):
        bed1_path = f'/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data/{group_num}/split_bed/chr{chr_num}_0{c}.bed'
        
        # 一次性读取 bed1 文件
        bed1 = pd.read_csv(bed1_path, sep='\t', header=None, names=['chr', 'start', 'end'])

        # 设置窗口大小
        window_size = 400
        step_size = 40

        # 获取所有可能的染色体
        chromosomes = set(bed1['chr']).union(set(bed2['chr']))

        # 结果列表
        results = []

        # 对每个染色体进行处理
        for chr in chromosomes:
            max_length = chr_len_dict[f'chr{chr_num}']
            print(max_length)

            for start in range(0, max_length - window_size + 1, step_size):
                end = start + window_size

                # 使用 Pandas 的 query 方法进行高效筛选
                count_bed1 = bed1.query('chr == @chr and start >= @start and end <= @end').shape[0]
                count_bed2 = bed2.query('chr == @chr and start >= @start and end <= @end').shape[0]

                ratio = count_bed1 / count_bed2 if count_bed2 > 0 else 'undefined'
                results.append({'chr': chr, 'start': start, 'end': end, 'ratio': ratio})

        result_df = pd.DataFrame(results)
        save_path = f"/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/results/{group_num}"
        output_file_path = f'{save_path}/chr{chr_num}_0{c}_ratios.csv'
        result_df.to_csv(output_file_path, index=False, sep='\t')
