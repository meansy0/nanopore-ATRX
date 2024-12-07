# Random colours that aren't white.


library(ggthemr)
# 定义自定义颜色列表
my_colors <- c("#FF5733", "#33FF57", "#3366FF", "#FF33CC", "#FFFF33", "#33FFFF", "#CC33FF", "#FF3333", "#33FFCC", "#99FF33")

diy_colors <- define_palette(
  swatch = my_colors,
  gradient = c(lower = my_colors[1L], upper = my_colors[2L])
)

ggthemr(diy_colors)




# 读取三个文件

path<-"/public/home/xiayini/project/nanopore_ATRX/2_vcfV3_analysis/data/joint_multi/difference_"
sample1="s31222_a509"
bed_path1=paste0(path,sample1,"/GC_count.1.bed")
file1 <- read.table(bed_path1, header = FALSE)[, 5]
file1 <- as.data.frame(file1)

sample2="s31222_a509_2"
bed_path2=paste0(path,sample2,"/GC_count.1.bed")
file2 <- read.table(bed_path2, header = FALSE)[, 5]
file2 <- as.data.frame(file2)

sample3="s31222_a509_3"
bed_path3=paste0(path,sample3,"/GC_count.1.bed")
file3 <- read.table(bed_path3, header = FALSE)[, 5]
file3 <- as.data.frame(file3)

colnames(file1) <- colnames(file2) <- colnames(file3) <- c("Value")


file1$Group <- rep("ATRX-0", nrow(file1))
file2$Group <- rep("ATRX-7", nrow(file2))
file3$Group <- rep("ATRX-16", nrow(file3))

# 合并三个文件的数据
merged_data <- rbind(file1, file2, file3)

# 使用 ggplot 绘制散点图
library(ggplot2)

library(dplyr)

# 计算均值和方差
summary_data <- merged_data %>%
  group_by(Group) %>%
  summarize(Mean = mean(Value), Variance = var(Value))

# 绘制散点图并标记均值和方差
ggplot(merged_data, aes(x = Group, y = Value, color = Group)) +
  geom_point() +
  labs(title = "Scatter Plot", x = "Group", y = "Value") +
  theme_minimal() +
  scale_color_manual(values = c("#8ECFC9", "#BEB8DC", "#FA7F6F")) +
  geom_text(data = summary_data, aes(label = paste("Mean:", round(Mean, 2), "\nVar:", round(Variance, 2)), x = Group, y = Mean), 
            vjust = -1.5, size = 5) +
  theme(
    axis.text.x = element_text(size = 20),  # 调整 x 轴标签字体大小
    axis.text.y = element_text(size = 20),  # 调整 y 轴标签字体大小
    legend.text = element_text(size = 20),  # 调整图例文字大小
    axis.title = element_text(size = 20),   # 调整轴标题字体大小
    plot.title = element_text(size = 20),   # 调整图表标题字体大小
    legend.title = element_text(size = 20)  # 调整图例标题字体大小
  )


library(ggplot2)

# 将Value按照范围划分为多个区间
merged_data$GC_Range <- cut(merged_data$Value, breaks = seq(0, 100, by = 10))

# 计算每个Group中每个范围内的值的数量
count_data <- merged_data %>%
  group_by(Group, GC_Range) %>%
  summarise(Count = n())

library(ggthemr, help, pos = 2, lib.loc = NULL)
ggthemr('grape')
# 绘制柱状图
ggplot(count_data, aes(x = GC_Range, y = Count, fill = GC_Range)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~Group, scales = "free") +
  labs(title = "GC Content Distribution by Group", x = "GC Content Range", y = "Count") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(size = 10, angle = 45, hjust = 1),  # 调整 x 轴标签字体大小和角度
    axis.text.y = element_text(size = 10),  # 调整 y 轴标签字体大小
    axis.title = element_text(size = 12),   # 调整轴标题字体大小
    plot.title = element_text(size = 14),   # 调整图表标题字体大小
    legend.position = "none"                # 不显示图例
  )



