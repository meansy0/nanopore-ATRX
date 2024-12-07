# 加载必要的库
# library(ggplot2)
# library(dplyr)

# 读取 CSV 文件
file_path <- "/public/home/xiayini/project/nanopore_ATRX/5_statistc/data/s31222_a509/sv.alt.insert.gc.csv"
data <- read.csv(file_path)

# 执行配对 Wilcoxon 检验
test_result <- wilcox.test(data$old_gc_content, data$new_gc_content, paired = TRUE)

# 绘制密度图，调整透明度
ggplot(data, aes(x = old_gc_content, fill = "Old GC Content")) +
  geom_density(alpha = 0.3) +  # 调整旧 GC 含量的透明度
  geom_density(aes(x = new_gc_content, fill = "New GC Content"), alpha = 0.3) +  # 调整新 GC 含量的透明度
  labs(title = "Comparison of Old and New GC Content", 
       x = "GC Content (%)", 
       y = "Density") +
  scale_fill_manual(values = c("Old GC Content" = "red", "New GC Content" = "blue")) +
  theme_minimal()

# 显示 p 值
print(test_result$p.value)
