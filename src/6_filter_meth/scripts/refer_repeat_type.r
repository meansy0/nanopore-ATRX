library(dplyr)
library(ggplot2)

data1 <- read.table("/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data/s31222_a509_3/meth/chr_all.txt")[,2]

# 读取数据
file<-'/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data/s31222_a509_3/chr1_repeat_meth.txt'
data <- read.table(file, header = FALSE, sep = "\t")

library(purrr)
# 对每个分类进行Wilcoxon秩和检验，并只保留p值小于0.05的结果
test_results <- data %>%
  split(.$V6) %>%
  map(~wilcox.test(data1, .x$V7,  alternative = "greater",,exact=FALSE)) %>%
  keep(~.$p.value < 0.05)

# 打印筛选后的检验结果
print(test_results)


# 假设列名是V1, V2, ..., V7
# 根据第五列(V5)分类，并计算第七列(V7)的平均值
average_values <- data %>%
  group_by(V6) %>%
  summarise(average = mean(V7))

# print(n=38,average_values)
print(average_values)
# 绘制散点图
# 假设你想根据第五列(V5)的分类在x轴上展示第七列(V7)的值
ggplot(data, aes(x = V5, y = V7)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) # 如果分类名称太长，可以将它们旋转90度
