
library(ggplot2)

# goup_num="a509_3"
# # 读取 TXT 文件
# txt_file <- paste0("/public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/",goup_num,"/chr_meth.txt")
# txt_data <- read.table(txt_file, header = FALSE, stringsAsFactors = FALSE)
# colnames(txt_data) <- c("Category", "ReferenceValue")

# 假设您已经有了从 BED 文件中提取的数据（selected_data）


# 读取数据
goup_num1="a509_2"
bed_file <- paste0("/public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/",goup_num1,"/repeat_meth/Chromsome.repeate.Simple_repeat.methRate.bed") # 请替换为您的文件路径
data <- read.table(bed_file, header = FALSE, stringsAsFactors = FALSE)

# 提取第4列和第11列
selected_data1 <- data[, c(4, 8)]
colnames(selected_data1) <- c("Value", "Category")

# 读取数据
# goup_num2="s31222"
goup_num2="a509"
bed_file <- paste0("/public/home/xiayini/project/nanopore_ATRX/7_single_meth/data/",goup_num2,"/repeat_meth/Chromsome.repeate.Simple_repeat.methRate.bed") # 请替换为您的文件路径
data <- read.table(bed_file, header = FALSE, stringsAsFactors = FALSE)

# 提取第4列和第11列
selected_data2 <- data[, c(4, 8)]
colnames(selected_data2) <- c("Value", "Category")

selected_data1$Group <- goup_num1
selected_data2$Group <- goup_num2
combined_data <- rbind(selected_data1, selected_data2)

# 获取所有唯一的类别
categories <- unique(combined_data$Category)

# 初始化结果列表
test_results <- list()

# 对每个类别进行检验
for (cat in categories) {
    data_cat <- subset(combined_data, Category == cat)
    # test_results[[cat]] <- wilcox.test(Value ~ Group, data = data_cat, exact = FALSE)
    test_results[[cat]] <- wilcox.test(Value ~ Group, data = data_cat, exact = FALSE,alternative = "less")
    # test_results[[cat]] <- wilcox.test(Value ~ Group, data = data_cat, exact = FALSE,alternative = "greater")
}

# 提取 p 值
p_values <- sapply(test_results, function(x) x$p.value)

# 转换为小数形式
p_values_decimal <- format(p_values, scientific = FALSE)

significant_categories <- p_values < 0.05

significant_p_values <- p_values[significant_categories]
print(significant_p_values)
significant_category_names <- names(significant_p_values)

significant_data <- combined_data
# 创建箱线图
p <- ggplot(significant_data, aes(x = Category, y = Value)) +
  geom_boxplot(fill = "lightblue", color = "blue") +
  labs(x = "Category", y = "Value") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
        axis.text.y = element_text(size = 12),
        plot.title = element_text(hjust = 0.5, size = 14)) +
  ggtitle("Boxplot of Values for Significant Categories")

# 打印图形
print(p)