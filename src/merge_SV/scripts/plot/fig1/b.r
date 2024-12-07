
# fig1-c：
# cat 1.bed 2.read.final.bed 3.bed |awk '{print "An"NR"\t"$0}' >save.bed
# 读取数据文件
bed_file <- "/public/home/xiayini/project/nanopore_ATRX/merge_SV/results/analysis/fig2/b_s31222_a509_a509_2.bed"
sv_data <- read.table(bed_file, header = FALSE)  # 包含位置和类别信息的数据文件

refer_len <- "/public/home/xiayini/reference/plot/len.txt"
chromosome_lengths <- read.table(refer_len, header = FALSE)  # 染色体长度信息文件
# awk '{print "A"NR"\t"$0}' your_file.txt > new_file.txt

# 使用 chromoMap 绘制染色体位置分布图
library("chromoMap")

# https://zhuanlan.zhihu.com/p/457797561
# 请注意，以下参数需要根据 chromoMap 函数的使用要求进行调整

# png(paste0(save_path,'c.png'))
# for type:line5 need be type
my_plot<-chromoMap(refer_len, bed_file,data_based_color_map = T,
          data_type = "categorical",
          data_colors = list(c("#8ECFC9","#BEB8DC","#FA7F6F","black")),
        #   data_colors = list(c("#8ECFC9","#BEB8DC","#FA7F6F")),
          chr_color="#FFE4E1")
library(htmlwidgets)
my_plot
saveWidget(my_plot, paste0(save_path,'c.html'), selfcontained = FALSE)
# for level:line5 need be number
chromoMap(refer_len, bed_file,
          data_based_color_map = T,
          data_type = "numeric",
          data_colors = list(c("#8ECFC9","#BEB8DC","#FA7F6F","black")),
          plots = "bar",
          plot_color = c("pink"),
          chr_color="#E7DAD2")

