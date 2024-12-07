# fig1-a：柱状图
# sv的数量
library(ggplot2)
library(tidyr)
library(dplyr)

# 读取数据
bed_file <- "/public/home/xiayini/project/nanopore_ATRX/5_statistc/scripts/fig1/SV_new.csv"
sv_data <- read.csv(bed_file, header = TRUE, stringsAsFactors = FALSE)

# 转换数据为长格式
long_data <- sv_data %>%
  select(SampleID, new_total_SV, dis_total_SV) %>%
  pivot_longer(cols = c(new_total_SV, dis_total_SV), names_to = "Type", values_to = "Count")

# 创建按照期望顺序排列的 Sample 列
desired_order <- c("Control-P0", "ATRX-P7", "ATRX-P16")
# 将 Sample 列转换为按照期望顺序排列的因子
long_data$SampleID <- factor(long_data$SampleID, levels = desired_order)

library(ggthemr, help, pos = 2, lib.loc = NULL)
ggthemr('grape')

# 绘制柱状图
example_plot<-ggplot(long_data, aes(x = SampleID, y = Count, fill = Type)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  theme_minimal() +
  labs(x = "Sample ID", y = "Total SV Count", fill = "SV Type") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  theme(
    axis.text.x = element_text(size = 20),  # 调整 x 轴标签字体大小
    axis.text.y = element_text(size = 20),  # 调整 y 轴标签字体大小
    legend.text = element_text(size = 20),  # 调整图例文字大小
    axis.title = element_text(size = 20),   # 调整轴标题字体大小
    plot.title = element_text(size = 20),   # 调整图表标题字体大小
    legend.title = element_text(size = 20)  # 调整图例标题字体大小
  )

save_path<-"/public/home/xiayini/project/nanopore_ATRX/5_statistc/results/fig1/"
ggsave(paste0(save_path, 'a', '.svg'), example_plot, width = 10, height = 8, dpi = 300)
example_plot


# fig1-c：
# cat 1.bed 2.read.final.bed 3.bed |awk '{print "An"NR"\t"$0}' >save.bed
# 读取数据文件
bed_file <- "/public/home/xiayini/project/nanopore_ATRX/2_vcfV3_analysis/data/joint_multi/difference_s31222_a509_3/fig1C.bed"
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
          chr_color="#FFE4E1")
library(htmlwidgets)
saveWidget(my_plot, paste0(save_path,'c.html'), selfcontained = FALSE)
# for level:line5 need be number
chromoMap(refer_len, bed_file,
          data_based_color_map = T,
          data_type = "numeric",
          data_colors = list(c("#8ECFC9","#BEB8DC","#FA7F6F","black")),
          plots = "bar",
          plot_color = c("pink"),
          chr_color="#E7DAD2")





# fig1-d：
# 读取数据
csv_file<-"/public/home/xiayini/project/nanopore_ATRX/5_statistc/scripts/fig1/repeat_chr.csv"
data <- read.csv(csv_file,header=TRUE)
# 加载所需的库
library(ggplot2)
library(tidyr)
# 将数据从宽格式转换为长格式，便于绘图
data_long <- gather(data, key = "chromosome", value = "value", -type_name)

# 散点图
ggplot(data_long, aes(x = type_name, y = value, color = type_name, shape = type_name)) +
  geom_point(position = position_dodge(width = 0.5), size = 4) +  # 调整点的大小
  labs(title = "Comparison of Type Names", x = "Type Name", y = "Value") +
  theme_minimal() +
  theme(
    axis.text = element_text(size = 14),  # 统一调整轴标签字体大小
    legend.text = element_text(size = 14),  # 调整图例文字大小
    axis.title = element_text(size = 16),  # 调整轴标题字体大小
    plot.title = element_text(size = 20, face = "bold"),  # 调整图表标题字体大小和加粗
    legend.title = element_text(size = 16),  # 调整图例标题字体大小
    panel.grid.major = element_line(color = "lightgray", linetype = "dashed"),  # 调整网格线样式
    panel.background = element_rect(fill = "white")  # 调整背景颜色
  )
# 备选：箱形图
example_plot<-ggplot(data_long, aes(x = type_name, y = value, fill = type_name)) +
  geom_boxplot(width = 0.5, alpha = 0.7) +
  geom_jitter(width = 0.2, alpha = 0.5, size = 2, color = "black") +  # 调整散点大小为2
  labs(title = "Comparison of Type Names", x = "Type Name", y = "Value") +
  theme_minimal() +
  theme(
    axis.text = element_text(size = 14),
    legend.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 20, face = "bold"),
    legend.title = element_text(size = 16),
    panel.grid.major = element_line(color = "lightgray", linetype = "dashed"),
    panel.background = element_rect(fill = "white")
  ) +
  scale_fill_manual(values = c("#8ECFC9","#BEB8DC")) 
ggsave(paste0(save_path, 'd', '.png'), example_plot, width = 10, height = 8, dpi = 300)


# 创建一个空的数据框来存放配对数据
paired_data <- data.frame(
  group = character(0), # 创建一个空的字符向量用于存放group标签
  value = numeric(0),   # 创建一个空的数值向量用于存放数值
  chr = character(0)    # 创建一个空的字符向量用于存放chr标签
)

# 对于每个chr，逐个添加对应的"Chromosomes"和"Repeats"的值
for (i in 2:ncol(data)) {
  # 提取"Chromosomes"和"Repeats"的对应列数据
  chromo_values <- data[data$type_name == "Chromosomes", i]
  repeats_values <- data[data$type_name == "Repeats", i]
  
  # 将对应的值和标签添加到配对数据中
  paired_data <- rbind(paired_data, data.frame(
    group = rep(c("Chromosomes", "Repeats"), each = length(chromo_values)),
    value = c(chromo_values, repeats_values),
    chr = rep(names(data)[i], times = length(chromo_values) * 2)
  ))
}

# 打印配对数据
print(paired_data)
paired_t_test <- t.test(value ~ group, paired_data)
paired_t_test










# Random colours that aren't white.
set.seed(12345)
random_colours <- sample(colors()[-c(1, 253, 361)], 10L)

ugly <- define_palette(
  swatch = random_colours,
  gradient = c(lower = random_colours[1L], upper = random_colours[2L])
)

ggthemr(ugly)

example_plot + ggtitle(':(')


