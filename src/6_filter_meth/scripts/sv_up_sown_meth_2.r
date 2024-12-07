
# plot for compare repeat and chr
group_num='s31222_a509'
# group_num='a509_s31222'
sv_type='DEL'
data1 <- read.table(paste0("/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data/",group_num,"/meth/chr_all.txt"))[,2]
data2 <- read.table(paste0("/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data/",group_num,"/sv/",sv_type,"/all_chr_sv.csv"))[,1]

test_result <- wilcox.test(data1, data2, alternative = "greater")
print(test_result)


library(ggplot2)

# 将数据组合成一个数据框，用于绘图
combined_data <- data.frame(
  value = c(data1, data2),
  group = factor(c(rep("Chr", length(data1)), rep("SV", length(data2))))
)
ggplot(combined_data, aes(x = group, y = value, fill = group)) +
  # 绘制条形图
  geom_bar(stat = "summary", fun = mean, position = position_dodge(), alpha = 0.7) +
  # 添加抖动的点
  geom_jitter(position = position_jitter(0.2), size = 2, alpha = 0.6) +
  # 使用更传统的颜色方案
  scale_fill_manual(values = c("#1f77b4", "#ff7f0e")) +
  # 使用简约风格的主题
  theme_minimal() +
  # 自定义主题
  theme(
    text = element_text(family = "sans", color = "#333333"),
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 12, face = "bold"),
    axis.text = element_text(size = 10),
    legend.position = "top",
    legend.title = element_blank(),
    legend.text = element_text(size = 10)
  ) +
  # 添加标签和标题
  labs(
    title = "Comparison of Mean Values with Individual Observations",
    x = "Group",
    y = "Value",
    caption = "Data Source: Your Data"
  )



library(ggplot2)
# plot for windows
data1 <- read.table("/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data/a509_s31222/sv/DEL/up_chr_sv_ratios.csv",header=FALSE)
headers <- c("chr", "start","end", "ratio")  # Replace ... with your actual header names

# Set the column names of the data frame
colnames(data1) <- headers

library(ggplot2)
library(dplyr)

# 假设您的数据框中有以下列：start, end, ratio

# 根据范围汇总数据
data_summarized <- data1 %>%
  group_by(start, end) %>%
  summarize(mean_ratio = mean(ratio)) %>%
  ungroup()


# 绘制区域图并添加美化选项
library(ggplot2)

# 定义线和点的颜色
line_color <- "darkblue"  # 线的颜色
point_color <- "#0099CC"  # 点的颜色，略微调整亮度和饱和度

# 绘制平滑曲线和原始点
ggplot(data_summarized, aes(x = end, y = mean_ratio)) +
  geom_smooth(method = "loess", se = FALSE, color = line_color, size = 1) +  # 修改线条颜色和粗细
  geom_point(data = data1, aes(x = end, y = ratio), color = point_color, size = 2) +  # 使用类似但不完全一样的颜色作为点的颜色
  labs(title = 'Ratio by Region', x = 'End Position', y = 'Ratio') +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        plot.title = element_text(hjust = 0.5),
        axis.title = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 10),
        legend.position = "bottom",
        legend.title = element_blank(),
        legend.text = element_text(size = 10),
        panel.background = element_blank(),
        panel.grid.major = element_line(color = "lightgray"),
        panel.grid.minor = element_blank(),
        plot.margin = margin(1, 1, 1, 1, "cm"))

# Save the plot as an SVG file
ggsave("/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/results/s31222_a509_3/sv_down.svg", width = 6, height = 4, units = "in", device = "svg")

