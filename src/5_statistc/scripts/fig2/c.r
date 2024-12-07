# 加载所需的库
library(ggplot2)

# 读取数据
group_num="s31222_a509_2"
setwd(paste0("/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter2Reads/",group_num,"/","three_locations/"))
data <- read.table("chr1.filter.txt", header=FALSE, sep="\t")

# 绘制第二列的直方图

ggplot(data, aes(x = V2)) +
  geom_histogram(fill = "#69b3a2", color = "#69b3a2") + # 更改颜色和边框
  theme_minimal() +
  labs(title = "Distribution of Values in Column 2",
       x = "Value",
       y = "Frequency") +
  theme(
    plot.title = element_text(hjust = 0.5), # 居中标题
    axis.text.x = element_text(angle = 45, hjust = 1), # 旋转X轴标签
    axis.title.x = element_text(size = 12, face = "bold"), # 加粗X轴标题
    axis.title.y = element_text(size = 12, face = "bold"), # 加粗Y轴标题
    legend.position = "none" # 隐藏图例
  ) +
  scale_x_continuous(labels = scales::comma) # 格式化X轴标签

# 保存图片
save_path="/public/home/xiayini/project/nanopore_ATRX/5_statistc/results/fig2"
ggsave(paste0(save_path,"/C_",group_num,"distribution.svg"), width = 8, height = 6)
