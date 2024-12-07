# 柱状图，sv的数量，包括增加的sv和减少的sv
# 创建示例数据 增加的sv
sample_data <- data.frame(
  Sample = c("a509_s31222", "s31222_a509_a509_2", "s31222_a509_2_a509_3"),
  DEL = c(49,67 , 251),
  INS = c(17, 37,86 ),
  DUP = c(3, 1, 1),
  INV = c(0, 2, 1)
)

# # 减少的sv
# sample_data <- data.frame(
#   Sample = c("a509_s31222", "s31222_a509_a509_2", "s31222_a509_2_a509_3"),
#   DEL = c(241,251 , 67),
#   INS = c(177, 86, 37),
#   DUP = c(3, 1, 1),
#   INV = c(0, 1, 2)
# )

# 载入 ggplot2 库
library(ggplot2)

# 将数据转换为长格式
library(reshape2)
sample_data_long <- melt(sample_data, id.vars = "Sample")

library(ggthemr, help, pos = 2, lib.loc = NULL)
ggthemr('lilac')

# 创建按照期望顺序排列的 Sample 列
desired_order <- c("a509_s31222", "s31222_a509_a509_2", "s31222_a509_2_a509_3")

# 将 Sample 列转换为按照期望顺序排列的因子
sample_data_long$Sample <- factor(sample_data_long$Sample, levels = desired_order)

# 绘制柱状图
example_plot <- ggplot(sample_data_long, aes(x = Sample, y = value, fill = variable)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Sample Data", x = "Sample", y = "Value") +
  scale_fill_discrete(name = "SV Type", labels = c("DEL", "INS", "DUP", "INV"))

example_plot



# Random colours that aren't white.
set.seed(12345)
random_colours <- sample(colors()[-c(1, 253, 361)], 10L)

ugly <- define_palette(
  swatch = random_colours,
  gradient = c(lower = random_colours[1L], upper = random_colours[2L])
)

ggthemr(ugly)

example_plot + ggtitle(':(')


