
# library(Biostrings)
# library(ggplot2)
# save_path<-'/public/home/xiayini/project/nanopore_ATRX/5_statistc/results/fig2/'

# # Read the methylation data
# methylation_data <- read.table("/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter2Reads/s31222_a509_2/three_locations/chr1.0.5.modifis_disappear.txt", header = FALSE, sep = "\t")
# # Extract the numeric value after the colon in the third column
# methylation_intensity <- sapply(strsplit(as.character(methylation_data$V3), ":"), function(x) as.numeric(unlist(strsplit(x[2], ","))[1]))


# # Create the plot
# plot2 <- ggplot(methylation_data, aes(x = V2, y = 1, color = methylation_intensity, group = 1)) +
#      geom_tile(aes(width = 0.1, height = 10), fill = NA) +  # Adjust width as needed
#      scale_color_gradient(low = "blue", high = "red") +
#      labs(title = "Actual Methylation Sites", x = "Position", y = "") +
#      theme_minimal() +
#      theme(axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())
# plot2

# ggsave(file.path(save_path,"meth_distri_chr1w.svg"), plot = plot2, width = 6, height = 4)




# # 安装并加载所需的包
# if (!requireNamespace("ggplot2", quietly = TRUE))
#     install.packages("ggplot2")

# # 读取pileup文件
# setwd("/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter2Reads/s31222_a509/")
# pileup_data <- read.table("chr1.merge.pileup", sep="\t", header=FALSE, fill=TRUE, comment.char="")
# colnames(pileup_data) <- c("Chromosome", "Position", "RefBase", "ReadCount", "ReadBases", "BaseQuality", "OtherInfo")

# # 创建散点图
# ggplot(pileup_data, aes(x=Position, y=ReadCount)) +
#     geom_point() +
#     theme_minimal() +
#     labs(title="甲基化位置读取数目可视化", x="位置", y="读取数目")

# ggplot(pileup_data, aes(x=Position, y=ReadCount, color=OtherInfo)) +
#     geom_point() +
#     geom_smooth(method = "loess", se = FALSE) +
#     theme_minimal() +
#     labs(title="甲基化位置读取数目与碱基类型", x="位置", y="读取数目", color="样本")






# # 安装并加载必要的包
# if (!requireNamespace("RColorBrewer", quietly = TRUE)) install.packages("RColorBrewer")
# library(ggplot2)
# library(dplyr)
# library(tidyr)
# library(RColorBrewer)

# # 读取数据
# sample_name="s31222_a509_3"
# chr_number="chr1"
# work_file1="/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data/s31222_a509/chr1.txt"
# work_file2="/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data/s31222_a509_2/chr1.txt"
# work_file3="/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data/s31222_a509_3/chr1.txt"


# data1 <- read.table(work_file1, header = FALSE, stringsAsFactors = FALSE)
# data2 <- read.table(work_file2, header = FALSE, stringsAsFactors = FALSE)
# data3 <- read.table(work_file3, header = FALSE, stringsAsFactors = FALSE)


# # 提取相关数据
# data$s31222 <- as.numeric(sapply(strsplit(data1$V3, "[,:]", perl=TRUE), function(x) x[2]))
# data$a509 <- as.numeric(sapply(strsplit(data1$V4, "[,:]", perl=TRUE), function(x) x[2]))
# data$a509_2 <- as.numeric(sapply(strsplit(data2$V4, "[,:]", perl=TRUE), function(x) x[2]))
# data$a509_3 <- as.numeric(sapply(strsplit(data3$V4, "[,:]", perl=TRUE), function(x) x[2]))

# # 转换数据为长格式
# long_data <- data %>%
#   select(V2, s31222, a509) %>%
#   pivot_longer(cols = c(s31222, a509), names_to = "sample", values_to = "value")

# # 定义更好看的配色方案
# color_scheme <- brewer.pal(3, "Set1")

# # 绘制散点图并添加平滑曲线
# plot2<-ggplot(long_data, aes(x = V2, y = value, color = sample)) +
#   geom_point() +
#   geom_smooth(method = "loess", se = FALSE) + # 添加平滑曲线
#   scale_color_manual(values = color_scheme) + # 使用自定义颜色
#   scale_x_continuous(labels = scales::comma) + # 使用常规数字格式而非科学计数法
#   theme_minimal() +
#   theme(
#     plot.title = element_text(size = 14, face = "bold"),
#     axis.title = element_text(size = 12),
#     legend.title = element_blank()
#   ) +
#   labs(x = "Position", y = "Value", title = paste0("Methlytaion rate in ",chr_number))

# plot2
# save_path="/public/home/xiayini/project/nanopore_ATRX/5_statistc/results/fig2/"
# svg_path=paste0(sample_name,"_meth_",chr_number,".svg")
# ggsave(file.path(save_path,svg_path), plot = plot2, width = 6, height = 4)




# library(ggplot2)
# library(dplyr)
# library(tidyr)
# library(RColorBrewer)

# # 读取数据
# chr_name="chr1"

# work_path1 <- "/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data/s31222_a509"
# work_path2 <- "/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/results/merge/s31222"


# s31222_data <- read.table(paste0(work_path2,"/",chr_name,"_all.txt"), header = FALSE, stringsAsFactors = FALSE)

# a509_data <- read.table(paste0(work_path1,"/",chr_name,".bed"), header = FALSE, stringsAsFactors = FALSE)
# a509_2_data <- read.table(paste0(work_path1,"_2/",chr_name,".bed"), header = FALSE, stringsAsFactors = FALSE)
# a509_3_data <- read.table(paste0(work_path1,"_3/",chr_name,".bed"), header = FALSE, stringsAsFactors = FALSE)


# # 转换数据为长格式
# long_data <- data %>%
#   pivot_longer(cols = c(s31222, a509, a509_2, a509_3), names_to = "sample", values_to = "value")

# # 定义更好看的配色方案
# color_scheme <- brewer.pal(4, "Set1")

# # 绘制散点图并添加平滑曲线
# plot2 <- ggplot(long_data, aes(x = V2, y = value, color = sample)) +
#   geom_point() +
#   geom_smooth(method = "loess", se = FALSE) + # 添加平滑曲线
#   scale_color_manual(values = color_scheme) + # 使用自定义颜色
#   scale_x_continuous(labels = scales::comma) + # 使用常规数字格式而非科学计数法
#   theme_minimal() +
#   theme(
#     plot.title = element_text(size = 14, face = "bold"),
#     axis.title = element_text(size = 12),
#     legend.title = element_blank()
#   ) +
#   labs(x = "Position", y = "Value", title = paste0("Methylation rate in ", chr_number))

# print(plot2)
# save_path <- "/public/home/xiayini/project/nanopore_ATRX/5_statistc/results/fig2/"
# svg_path <- paste0(sample_name, "_meth_", chr_number, ".svg")
# ggsave(file.path(save_path, svg_path), plot = plot2, width = 6, height = 4)



library(dplyr)
library(tidyr)
library(ggplot2)
library(RColorBrewer)

# 读取数据
chr_name <- "chr1"
work_path1 <- "/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data/s31222_a509"
work_path2 <- "/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/results/merge/s31222"

# 读取数据集
s31222_data <- read.table(paste0(work_path2, "/", chr_name, "_all.txt"), header = FALSE, stringsAsFactors = FALSE)
a509_data <- read.table(paste0(work_path1, "/", chr_name, ".bed"), header = FALSE, stringsAsFactors = FALSE)
a509_2_data <- read.table(paste0(work_path1, "_2/", chr_name, ".bed"), header = FALSE, stringsAsFactors = FALSE)
a509_3_data <- read.table(paste0(work_path1, "_3/", chr_name, ".bed"), header = FALSE, stringsAsFactors = FALSE)

# 确保所有数据集有相同的列名
colnames(s31222_data) <- colnames(a509_data) <- colnames(a509_2_data) <- colnames(a509_3_data) <- c("chr", "start", "end", "value")

# 假设数据集中的甲基化值在第四列
colnames(s31222_data)[4] <- "s31222"
colnames(a509_data)[4] <- "a509"
colnames(a509_2_data)[4] <- "a509_2"
colnames(a509_3_data)[4] <- "a509_3"

# 合并数据集
all_data <- full_join(s31222_data, a509_data, by = c("chr", "start", "end"))
all_data <- full_join(all_data, a509_2_data, by = c("chr", "start", "end"))
all_data <- full_join(all_data, a509_3_data, by = c("chr", "start", "end"))

# 用0填充缺失的数据
all_data[is.na(all_data)] <- 0

# 转换数据为长格式
long_data <- all_data %>%
  select(chr, start, end, s31222, a509, a509_2, a509_3) %>%
  pivot_longer(cols = c(s31222, a509, a509_2, a509_3), names_to = "sample", values_to = "value")


# 定义更好看的配色方案
color_scheme <- brewer.pal(4, "Set1")

# 绘制散点图并添加平滑曲线
plot2 <- ggplot(long_data, aes(x = start, y = value, color = sample)) +
  geom_point() +
  geom_smooth(method = "loess", se = FALSE) + # 添加平滑曲线
  scale_color_manual(values = color_scheme) + # 使用自定义颜色
  scale_x_continuous(labels = scales::comma) + # 使用常规数字格式而非科学计数法
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    axis.title = element_text(size = 12),
    legend.title = element_blank()
  ) +
  labs(x = "Position", y = "Value", title = paste0("Methylation rate in ", chr_name))



save_path <- "/public/home/xiayini/project/nanopore_ATRX/5_statistc/results/fig2"
svg_path <- paste0("a_all_meth_", chr_name, ".svg")
ggsave(file.path(save_path, svg_path), plot = plot2, width = 6, height = 4)
