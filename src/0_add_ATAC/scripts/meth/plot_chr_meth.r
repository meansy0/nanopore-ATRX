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