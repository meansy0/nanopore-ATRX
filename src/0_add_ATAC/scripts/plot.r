# 加载必要的库
library(ggplot2)
library(dplyr)

# 读取数据
path="/public/home/xiayini/project/nanopore_ATRX/0_add_ATAC/data"
data <- read.delim(paste0(path,"chr1.txt"), header = FALSE)

# 数据处理 - 提取基因名称
data$gene <- sapply(strsplit(as.character(data$V10), ";"), function(x) unlist(strsplit(x[which(grepl("gene=", x))], "="))[2])

# 计算每个基因的甲基化修饰数量
gene_methylation_counts <- data %>%
  group_by(gene) %>%
  summarise(count = n())

# 绘制柱状图
ggplot(gene_methylation_counts, aes(x = gene, y = count)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("Gene") +
  ylab("Count of Methylation Modifications") +
  ggtitle("Methylation Modifications per Gene")
