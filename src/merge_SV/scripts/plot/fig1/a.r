# fig1-a：柱状图
# sv的数量
library(ggplot2)
library(tidyr)
library(dplyr)

# 读取数据
bed_file <- "/public/home/xiayini/project/nanopore_ATRX/merge_SV/results/analysis/fig1/a_total_SV.csv"
sv_data <- read.csv(bed_file, header = TRUE, stringsAsFactors = FALSE)

# 转换数据为长格式
long_data <- sv_data %>%
  select(SampleID, new_total_SV, dis_total_SV) %>%
  pivot_longer(cols = c(new_total_SV, dis_total_SV), names_to = "Type", values_to = "Count")

# 创建按照期望顺序排列的 Sample 列
desired_order <- c("A509_S31222", "S31222_A509_A509_2", "S31222_A509_2_A509_3")
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

save_path<-"/public/home/xiayini/project/nanopore_ATRX/merge_SV/results/plot/fig1/"
ggsave(paste0(save_path, 'a', '.svg'), example_plot, width = 10, height = 8, dpi = 300)
example_plot
